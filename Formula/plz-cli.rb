class PlzCli < Formula
  desc "Copilot for your terminal"
  homepage "https://github.com/m1guelpf/plz-cli"
  url "https://github.com/m1guelpf/plz-cli/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "c6f20fc3b60caa39b347b38054f5f1f766339ecf4ab0ef19864ef5cbe18f520d"
  license "MIT"
  head "https://github.com/m1guelpf/plz-cli.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["OPENAI_API_KEY"] = "sk-XXXXXXXX"
    expected = "✖ Failed to get a response. Have you set the OPENAI_API_KEY variable?"
    assert_match expected, shell_output("#{bin}/plz brewtest", 1)
  end
end
