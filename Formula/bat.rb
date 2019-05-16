class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.11.0.tar.gz"
  sha256 "bb4e39efadfab71c0c929a92b82dac58deacfe2a4eb527d4256ac0634e042ed2"

  bottle do
    cellar :any_skip_relocation
    sha256 "37569e54d49b1dd2964cae42a0c0d0079cf8c0f308212d13324744ee8ee31302" => :mojave
    sha256 "66bca14eb7dcdb7f46c941d638a3778677833876aea020dc3d8fb871dc4cfce1" => :high_sierra
    sha256 "1e91e700d6e0bc9f6ea5d9f636309ad06cf4f533368c900ce69d7e45654c00b2" => :sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/bat.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
