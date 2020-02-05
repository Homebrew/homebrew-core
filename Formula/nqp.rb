class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://github.com/perl6/nqp/releases/download/2020.01/nqp-2020.01.tar.gz"
  sha256 "4ccc9c194322c73f4c8ba681e277231479fcc2307642eeeb0f7caa149332965b"

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
