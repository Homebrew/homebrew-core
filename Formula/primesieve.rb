class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "http://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v6.0.tar.gz"
  sha256 "4b462d9682c595fc4d332c9b22240c571a4c0d8331bcb38c854a50d36229678a"

  bottle do
    cellar :any
    sha256 "5e50eb398e186c61cf06d17d4c4cc3a42f5424ed40400f4392e9bcd890ae5951" => :sierra
    sha256 "bbf14a1041b404069102a0eb853fdfe8d099ccb3aa67a9b453e42f560919c4d9" => :el_capitan
    sha256 "159886a4250641220e2ef2c41f58caf3c595485df32340f68e9007214a860e6a" => :yosemite
    sha256 "b15504dd7f1bfb4cd9dc5d4474b7180bd5b345d49e10619f5383516efa061964" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
