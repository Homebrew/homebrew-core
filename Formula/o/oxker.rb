class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "e58c061519d4b5baade0651d18a0c0b7165dcaecf87db00f1d11c582e2dbea45"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82f9addafe5f31ce725dd27bf16c6beab338f198ffd78dfed49c959a3d35b703"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6bbdef33b4a341aa6e8da98a03e549871258c6f8388126cddb6e293bbe3b14a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38c96d3d6f7f8c56aed4979be8a326fde8022707303a09fbb45da9de64f08834"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dcf7a2b97ea73cfd3d7cbd581a2d56a68ec9865a898313a1f3c51bcbea089ef"
    sha256 cellar: :any,                 arm64_linux:   "831d4c3a6ccb7afb7353fd1db9df87dd7deb1dacc3b6fd3970dc2a49e664580c"
    sha256 cellar: :any,                 x86_64_linux:  "1f319283130ee2fcdb48f817213028d85378380175779091ba73f208eb3f2054"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output("#{bin}/oxker --host 2>&1", 2)
  end
end
