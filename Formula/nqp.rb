class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  # NOTE: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/perl6/nqp/releases/download/2021.05/nqp-2021.05.tar.gz"
  sha256 "b43cf9d25a8b3187c7e132e1edda647d58bc353ca0fb534cc9aa0f8df7fff73f"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "07ecf7c1a2a3e7828f0adb8a73455f79cb809ca9de4abb9ecb827e0b398ee9c9"
    sha256 big_sur:       "36586eed6dc67ec69b7cc50dae7cad642b934aaf800a49a4a345b3ad0ea3cd8d"
    sha256 catalina:      "bec61301ce358f0ab6770da4642ececc5ae45082f67ff7b614e08e40ae3ed5b6"
    sha256 mojave:        "4edc1cb23d10256eb85d1a5d08752f8a8905d19420034b440d24869a63fd2ef7"
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
