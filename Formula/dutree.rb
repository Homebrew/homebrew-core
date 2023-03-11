class Dutree < Formula
  desc "Tool to analyze file system usage written in Rust"
  homepage "https://github.com/nachoparker/dutree"
  url "https://github.com/nachoparker/dutree/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "55c30e57cc339dd16141510af33245cc3b82f588f22419fc034f02b36ebecba0"
  license "GPL-3.0-only"
  head "https://github.com/nachoparker/dutree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cf132b20727d426b4db9cf9002881fd1a6deead6c7946d1fb587fee88b3f297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce3b7ffe71986b87939fa203fb329153181a09e3959dc80074e14bdabfce2bf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff5818c530c77c1213688ddc314fb26c0f9c2e117cf6b014ed012cd40525c760"
    sha256 cellar: :any_skip_relocation, ventura:        "2ccacb1b47b7c491dfe861c28b63ee1c134cf798494e4626cff8affaabccd1b9"
    sha256 cellar: :any_skip_relocation, monterey:       "53b9d1818729192217fe07029f62de3fbdd468933487e881135455f15f05b254"
    sha256 cellar: :any_skip_relocation, big_sur:        "d023124a064c2be039be8d2fb1629c9688a94a71359392a5c825e3304b958246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ff2f1f3ea275dfef72124d45733be37ebf069eb4bb20bed09a33f3e2d68420"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"brewtest"
    assert_match "brewtest", shell_output("#{bin}/dutree --usage #{testpath}")

    assert_match "dutree version #{version}", shell_output("#{bin}/dutree --version")
  end
end
