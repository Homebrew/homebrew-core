class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "http://primesieve.org/"
  url "https://dl.bintray.com/kimwalisch/primesieve/primesieve-5.7.0.tar.gz"
  sha256 "4a3e542dd3079dd9c0caf2d67fbb7b79757f65d705bdc8cf50555e65653fa1d1"

  bottle do
    cellar :any
    sha256 "5e50eb398e186c61cf06d17d4c4cc3a42f5424ed40400f4392e9bcd890ae5951" => :sierra
    sha256 "bbf14a1041b404069102a0eb853fdfe8d099ccb3aa67a9b453e42f560919c4d9" => :el_capitan
    sha256 "159886a4250641220e2ef2c41f58caf3c595485df32340f68e9007214a860e6a" => :yosemite
    sha256 "b15504dd7f1bfb4cd9dc5d4474b7180bd5b345d49e10619f5383516efa061964" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/primesieve", "2", "1000", "--count=1", "-p2"
  end
end
