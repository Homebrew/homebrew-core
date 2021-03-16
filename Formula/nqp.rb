class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  # NOTE: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/perl6/nqp/releases/download/2021.02/nqp-2021.02.tar.gz"
  sha256 "d24b1dc8c9f5e743787098a19c9d17b75f57dd34d293716d5b15b9105037d4ef"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "73a1af34da7376ffcf48159792a45df3c8ef7eedcf4d2cc5bfb27f754e0920ac"
    sha256 big_sur:       "8f4def608ca0adfbd3b334cf1136245a37b643365b6461c9909b65e8386ffcb1"
    sha256 catalina:      "2e9e529c542c4d90aa4e70989d387d49574d283c66e1fa8d66efd4471066c4fd"
    sha256 mojave:        "a9fd95bb902d3c46d26758e705aba442fc881b2c8831407de999019c0acbf31f"
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
