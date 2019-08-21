class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://github.com/perl6/nqp/releases/download/2019.07.1/nqp-2019.07.1.tar.gz"
  sha256 "7324e5b84903c5063303a3c9fb6205bdf5f071c9778cc695ea746e7d41b12224"

  bottle do
    sha256 "187e1643a69732e3f4fd6051e983c0b1821820ca70b50f79d2583d0001034a74" => :mojave
    sha256 "76217f74bb225f9c1897e71f3157292b3e17de7913e12d9a6d70fbc340d35c88" => :high_sierra
    sha256 "6c521de7bb7b1f39ee68c60be72e0de5cacbee807dbdaff079a68c38bc95a6db" => :sierra
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
