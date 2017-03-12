class Libcds < Formula
  desc "C++ library of Concurrent Data Structures"
  homepage "https://libcds.sourceforge.io/doc/cds-api/index.html"
  url "https://github.com/khizmax/libcds/archive/v2.2.0.tar.gz"
  sha256 "e582fbd6492c91ff24b11468f094b111d5f62eca69e6445c88bf16cad50e40ed"

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    if MacOS.version >= "10.10"
      system "cmake", ".", "-DCMAKE_CXX_FLAGS='-stdlib=libc++ -std=c++11'", *std_cmake_args
    else
      system "cmake", ".", "-DWITH_BOOST_ATOMIC=ON", *std_cmake_args
    end
    system "make"
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
