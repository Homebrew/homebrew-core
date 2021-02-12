class Pcalc < Formula
  desc "Calculator for those working with multiple bases, sizes, and close to the bits"
  homepage "https://github.com/alt-romes/programmer-calculator"
  url "https://github.com/alt-romes/programmer-calculator/archive/v2.0.1.tar.gz"
  sha256 "a3b8b59bd4da9a1ee39f73303e18005f2b4a45b655f7a7cca10aa9ce173610e7"
  license "GPL-3.0-or-later"

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
