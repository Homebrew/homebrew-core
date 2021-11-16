class Pcalc < Formula
  desc "Calculator for those working with multiple bases, sizes, and close to the bits"
  homepage "https://github.com/alt-romes/programmer-calculator"
  url "https://github.com/alt-romes/programmer-calculator/archive/v2.2.tar.gz"
  sha256 "d76c1d641cdb7d0b68dd30d4ef96d6ccf16cad886b01b4464bdbf3a2fa976172"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06f18a787692665a694a12aafcc994c92b92c7a6c6ba80e71b683a70c347b53d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "394ca2ef67e980b0fbc55c29e3623ef8adf24392e129489f640a1aa6b011dacd"
    sha256 cellar: :any_skip_relocation, monterey:       "2d6a24eaa904eb158ad9058c6491f283504965d4bb77984505998c090510d3b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "109563ed8739d73cb64ceb8bfb35ceaa0e002d5af6cf0f63b1d52ca84fd4b8c6"
    sha256 cellar: :any_skip_relocation, catalina:       "afbf577c7349e107f117dc18d6f9247e8cc307601573c19f5f3c3aada892b867"
    sha256 cellar: :any_skip_relocation, mojave:         "c7b810b53b109c4bfa80ec2a2b834b9d56c129d5252c42cf6cce1693b9482d5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27301e52812906befad81cec82873a8fdc5de83deac99b6f80004876de6567d6"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "pcalc"
  end

  test do
    assert_equal "Decimal: 0, Hex: 0x0, Operation:  \nDecimal: 3, Hex: 0x3, Operation:",
      shell_output("echo \"0x1+0b1+1\nquit\" | #{bin}/pcalc -n").strip
  end
end
