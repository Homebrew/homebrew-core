class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "25911ada6375169aef59a6356685dd528609e44895ef295c6b134b3697aa9c72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c392acd86de0659f6d82059e4a7f091f1b1deae6b55da2bdbd982b1d9076442"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "091a790aa53bd7e51068be76ee27ee560564ad5ac22158e35ce25b732725bdd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "432307982acde67542c63ef8e35e88ba935ce5ff67639f3d426c309f0bdfd6a5"
    sha256 cellar: :any,                 arm64_linux:       "be3b62e6579aacd8f051fc7b4733a6be1744f372eda0961c41b9521f07eb01db"
    sha256 cellar: :any,                 x86_64_linux:      "cb2ce08e58a0b9198a609429c316abca4ec58f1979d8ef85beb07f699c5fa286"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end
