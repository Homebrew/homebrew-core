class Kuaa < Formula
  desc "CLI tool to enhance Git workflow productivity using AI to craft commits"
  homepage "https://kuaa.tools"
  url "https://github.com/Tavernari/kuaa/archive/refs/tags/0.0.1.tar.gz"
  sha256 "fdb9865ae323d7460fd2caec3d489d399f479fe3eaf86f8cc8f2cb950276f463"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test for missing API key error
    output_balance = shell_output("#{bin}/kuaa balance 2>&1", 1)
    assert_match(/environment variable is not set/, output_balance)
    assert_match(/To set the API key, run: kuaa config api-key <YOUR_API_KEY>/, output_balance)

    # Test handling of the config command with a fake API key
    fake_api_key = "12345"
    output_config = shell_output("#{bin}/kuaa config api-key #{fake_api_key} 2>&1")
    assert_match(/Setting API key to: #{fake_api_key}/, output_config)

    # Try to fetch the balance with the fake API key set (expecting failure due to invalid key)
    output_balance_after_config = shell_output("#{bin}/kuaa balance 2>&1", 1)
    assert_match(/environment variable is not set/, output_balance_after_config)

    # Test the generation command expecting no staged changes error
    output_gen = shell_output("#{bin}/kuaa gen git-commit-message 2>&1", 1)
    assert_match(/No staged changes to generate a commit message./, output_gen)

    # Test invalid command error handling
    output_invalid = shell_output("#{bin}/kuaa invalid-command 2>&1", 1)
    assert_match(/error: Found argument 'invalid-command' which wasn't expected/, output_invalid)
  end
end
