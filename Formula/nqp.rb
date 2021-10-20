class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  # NOTE: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/Raku/nqp/releases/download/2021.09/nqp-2021.09.tar.gz"
  sha256 "7f296eecb3417e28a08372642247124ca2413b595f30e959a0c9938a625c82d8"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "e051ae40df0024c1da8535526281d9e4792d09df5f3fe73200919d8b09e21eed"
    sha256 big_sur:       "cc89fa68750a499ac0b163d68090d846cf112c4de6c21bfedddfe963dfdc3e18"
    sha256 catalina:      "a3a1c7bf1f1eebbb5b02c23f705a4857ca96607410babfed6258b05d2a692e28"
    sha256 mojave:        "a15709a3ef54e9cba15b708db9fdc8b8a8421344fe7bff7e1462757906389b7a"
  end

  depends_on "libtommath"
  depends_on "moarvm"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
