class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://github.com/perl6/nqp/releases/download/2019.07.1/nqp-2019.07.1.tar.gz"
  sha256 "7324e5b84903c5063303a3c9fb6205bdf5f071c9778cc695ea746e7d41b12224"

  bottle do
    sha256 "c7747356d849dd27f1802875cb2383223d1d96fad1e4f100be2946a5edf66a3d" => :mojave
    sha256 "0dac855e4e76e14d7e3d01eaaf72ed72d63e54a716c3973a4430d6a7a1aac219" => :high_sierra
    sha256 "f26043b2ccce1c98b82d733c57ccfa06049e44ee5df42829d54bc789668371d9" => :sierra
  end

  depends_on "moarvm"

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
