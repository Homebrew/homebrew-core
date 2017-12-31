class Libcds < Formula
  desc "C++ library of Concurrent Data Structures"
  homepage "https://libcds.sourceforge.io/doc/cds-api/index.html"
  url "https://github.com/khizmax/libcds/archive/v2.3.2.tar.gz"
  sha256 "c174dc6c142e6c69b515186c597d8eb5f7add0040a4e64d4d77596bbfa2e977c"

  bottle do
    cellar :any
    sha256 "b1fb46232f36fd9bc2fef02b1118e5398609b3343b3376d5130a5c7633c7c9ae" => :high_sierra
    sha256 "cf6b35c96cdf54f090fb02f519bb00581ae9e4214416dbeabdc89235a5c94e57" => :sierra
    sha256 "5f6db23a55e3bc9ce3358662b1f9122e9eb032f7eedef4b47e6bf9f27ebc052d" => :el_capitan
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
    (testpath/"test.cpp").write <<~EOS
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
