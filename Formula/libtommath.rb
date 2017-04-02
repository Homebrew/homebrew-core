class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "http://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.0/ltm-1.0.tar.xz"
  sha256 "993a7df9ee091fca430cdde3263df57d88ef62af8103903214da49fc51bbb56c"
  head "https://github.com/libtom/libtommath.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c5da0ecce4ba1a208b0556aefe34599e6846876f6a6fc5d5a6acde06519101c" => :sierra
    sha256 "d4397cca9659c99660ef0a2c5e3b580cf60cc2748171592f0b61d596cdbb75a1" => :el_capitan
    sha256 "9475003c6454215fbf018835460a2a6b681abc719be6176132473128237921f7" => :yosemite
  end

  def install
    ENV["DESTDIR"] = prefix

    system "make"
    system "make", "test_standalone"
    include.install Dir["tommath*.h"]
    lib.install "libtommath.a"
    pkgshare.install "test"
  end

  test do
    system pkgshare/"test"
  end
end
