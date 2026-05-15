class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.11.51.tar.gz"
  sha256 "0746fa3bff4bb731b3bfec7a768779659f3ae4033a3c862a31568062440244e9"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb9ff719bd6d3715f25a1520ed5581e5cf96ce619e1dc986deca9aae20ef4668"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9983d80184df75bc912ef9aea7e3ec4acfbc15ad4997bbb419abd90afac992d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5d911d4c94272e35aa227aecb2693c6dc166339b793b0fae231ad53b89622a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "decb3a4ca70bdff686d8ec0a47ff86a1e351c689e086b2f4bac33ceadcc7f8a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1268c9c3ffefb463a949faebaad92691fbd65a5801ee61e25e2ad9a0d1e5d5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a87829e12c90a7f3537913e5f9f003690c892a70bccffa147fd719e9c3eb599"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")
    assert_match "claude-code", shell_output("#{bin}/models agents list-sources")
  end
end
