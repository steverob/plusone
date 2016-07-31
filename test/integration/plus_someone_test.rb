require 'test_helper'

class PlusSomeoneTest < ActionDispatch::IntegrationTest

  test "increases points for recipient" do
    team_domain = "team1"
    team_id = "team_id1"
    sender_name = "user_name1"
    sender_id = "user_id1"
    recipient_name = "user_name2"
    trigger_word = "+1"

    stats_params = {
      trigger_word: trigger_word,
      text: "#{trigger_word} !stats",
      team_id: team_id,
      team_domain: team_domain,
      format: :json
    }

    plus_params = {
      team_domain: team_domain,
      trigger_word: trigger_word,
      text: "#{trigger_word} #{recipient_name}",
      team_id: team_id,
      user_name: sender_name,
      user_id: sender_id,
      format: :json
    }

    post "/slack/plus", plus_params
    post "/slack", stats_params
    response_text = JSON(response.body)["text"]
    expected_response = "user_name2: 1, user_name1: 0"
    assert_equal(response_text, expected_response)
  end

  test "doesnt increase points if sender is recipient" do
    team_domain = "team1"
    team_id = "team_id1"
    sender_name = "user_name1"
    sender_id = "user_id1"
    trigger_word = "+1"

    stats_params = {
      trigger_word: trigger_word,
      text: "#{trigger_word} !stats",
      team_id: team_id,
      team_domain: team_domain,
      format: :json
    }

    plus_params = {
      team_domain: team_domain,
      trigger_word: trigger_word,
      text: "#{trigger_word} #{sender_name}",
      team_id: team_id,
      user_name: sender_name,
      user_id: sender_id,
      format: :json
    }

    post "/slack/plus", plus_params
    plus_response_text = JSON(response.body)["text"]
    expected_plus_response = "Nope... not gonna happen."
    assert_equal(plus_response_text, expected_plus_response)
    post "/slack", stats_params
    response_text = JSON(response.body)["text"]
    expected_response = ""
    assert_equal(response_text, expected_response)
  end

end