class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  # NOTE: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/Raku/nqp/releases/download/2021.08/nqp-2021.08.tar.gz"
  sha256 "bb01cf11cbba910047259b75c8bfba83b557acaab170f64f24810fbd5f69319b"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "00b709dc037e78fe9f02887a27ea81d290f2c4bf2efacd8b6c98e99b4bade70f"
    sha256 big_sur:       "084b3c8e452b508cc9aa0fbd2d5ac1c7201ede4c9e264e09d359ac1e4ca32bf5"
    sha256 catalina:      "bd81778fcb27c46e23c3f0fad3f48e3be86e6d80ee6667732c4cd3ba050262ee"
    sha256 mojave:        "62f968288f666a49aab55acab46a4de09dc7b09d449871c360ef5564822fb0a3"
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
