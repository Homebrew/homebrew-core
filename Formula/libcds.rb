class Libcds < Formula
  desc "C++ library of Concurrent Data Structures"
  homepage "https://libcds.sourceforge.io/doc/cds-api/index.html"
  url "https://github.com/khizmax/libcds/archive/v2.3.0.tar.gz"
  sha256 "4e9f64ee350ce69daad2a1d620474ed79de593816bfb1bb2cb202c8d24944d79"

  bottle do
    cellar :any
    sha256 "451794b5aaadd44b84f3ade6b0414b3d499c06a95616be80df3c87fd58fb685a" => :sierra
    sha256 "dabaef0779c0acead8e430c9e18988b76396e8701944b614dc7251c0590a68b6" => :el_capitan
    sha256 "3d3a7b2cf90aa63eab440ee1ff892c6940b5f95b2fcb046cfc87c71f016eacb1" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  if DevelopmentTools.clang_build_version < 800
    depends_on "gcc"
    fails_with :clang
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <cds/init.h>
      int main() {
        cds::Initialize();
        cds::threading::Manager::attachThread();
        cds::Terminate();
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-L#{lib}64", "-lcds", "-std=c++11"
    system "./test"
  end
end
