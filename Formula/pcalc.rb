class Pcalc < Formula
  desc "Calculator for those working with multiple bases, sizes, and close to the bits"
  homepage "https://github.com/alt-romes/programmer-calculator"
  url "https://github.com/alt-romes/programmer-calculator/archive/v2.0.1.tar.gz"
  sha256 "a3b8b59bd4da9a1ee39f73303e18005f2b4a45b655f7a7cca10aa9ce173610e7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d7268ccb14450e15d1615919272edc4e365670c54daf7fb6b9de272c6eddf6b"
    sha256 cellar: :any_skip_relocation, big_sur:       "b81ac1f8cc3d7ab174d2cd4873571da42988259af0ec6eaf21a277c5dcf08842"
    sha256 cellar: :any_skip_relocation, catalina:      "cb6c78a7399eaeeee80f0d23863bbe60dd011171b0251e512d6c581b3947c4ea"
    sha256 cellar: :any_skip_relocation, mojave:        "a66a10045261aece457eba2a4d7ef8bdd4af4e3218877a94c48797d34d54d137"
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
