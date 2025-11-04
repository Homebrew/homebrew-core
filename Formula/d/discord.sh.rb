class DiscordSh < Formula
  desc "Write-only command-line Discord webhooks integration"
  homepage "https://github.com/fieu/discord.sh"
  url "https://github.com/fieu/discord.sh/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "49e92bf242f68bee9d739adf77af08ea5ccb58cd0c406a6e25eef42e27a25dcd"
  license "GPL-3.0-or-later"

  depends_on "bash"
  depends_on "jq"

  uses_from_macos "curl"

  def install
    bin.install "discord.sh"
  end

  test do
    assert_match "{ \"wait\": true, \"content\": \"Hello, world\" }", shell_output("#{bin}/discord.sh --webhook-url https://example.com --text \"Hello, world\" --dry-run 2>&1")

    assert_predicate bin/"discord.sh", :executable?
  end
end
