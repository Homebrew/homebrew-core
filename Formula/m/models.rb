class Models < Formula
  desc "TUI for browsing AI models, benchmarks, and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "d49d819ff8e67b580a9d53a57267821eb8e767fc9748b58a2fbd81a823d06adf"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")
  end
end
