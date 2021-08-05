class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  # NOTE: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/Raku/nqp/releases/download/2021.07/nqp-2021.07.tar.gz"
  sha256 "dcaaf2a43ab3b752be6f4147a88abdc5b897e5ba85e536a0282bde8e4d363ea4"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "54666f9c17dc280c8789083887dcde23e22760c1c277009bae6543ce01d2404d"
    sha256 big_sur:       "1e317a9bb0517e8eac3476ebf2c0cc553a5f7b36efbc5dd2c6573e742dd5a596"
    sha256 catalina:      "9941e3267f32e988155c86b1d722ce364f2701165bda41d99a876e279bde4d75"
    sha256 mojave:        "9c2564aeed8860f60605766435b547cef3119dd100f57558bd83e88ebee99775"
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
