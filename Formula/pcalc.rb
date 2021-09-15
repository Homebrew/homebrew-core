class Pcalc < Formula
  desc "Calculator for those working with multiple bases, sizes, and close to the bits"
  homepage "https://github.com/alt-romes/programmer-calculator"
  url "https://github.com/alt-romes/programmer-calculator/archive/v2.1.tar.gz"
  sha256 "27cba8e04e73f1a2fbb4900abbf450fee07f7691c709addde21e5bb7a44c9988"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "394ca2ef67e980b0fbc55c29e3623ef8adf24392e129489f640a1aa6b011dacd"
    sha256 cellar: :any_skip_relocation, big_sur:       "109563ed8739d73cb64ceb8bfb35ceaa0e002d5af6cf0f63b1d52ca84fd4b8c6"
    sha256 cellar: :any_skip_relocation, catalina:      "afbf577c7349e107f117dc18d6f9247e8cc307601573c19f5f3c3aada892b867"
    sha256 cellar: :any_skip_relocation, mojave:        "c7b810b53b109c4bfa80ec2a2b834b9d56c129d5252c42cf6cce1693b9482d5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27301e52812906befad81cec82873a8fdc5de83deac99b6f80004876de6567d6"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "pcalc"
  end

  test do
    assert_equal "Decimal: 0, Hex: 0x0, Operation:  \nDecimal: 3, Hex: 0x3, Operation:",
      shell_output("echo \"0x1+0b1+1\nquit\" | #{bin}/pcalc -c").strip
  end
end
