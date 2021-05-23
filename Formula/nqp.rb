class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  # NOTE: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/perl6/nqp/releases/download/2021.05/nqp-2021.05.tar.gz"
  sha256 "b43cf9d25a8b3187c7e132e1edda647d58bc353ca0fb534cc9aa0f8df7fff73f"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "92fc94de6c0e038ae9e12d7894d320f0e4c9fe26e02dfe004cb184907d9e1715"
    sha256 big_sur:       "c4f9d7ef588ab16b0d9df0bd91372f9e8fc662fcf8b26ac0d9b5bd76dc3589db"
    sha256 catalina:      "93f1bea6423c3ac58612343be42e17d7e5b2ed9c970e640d2501ef6b31760131"
    sha256 mojave:        "a71d0675ca8a24022a09202722bfe72ad8b18e14bf6bbe6382c9362f095fd2e8"
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
