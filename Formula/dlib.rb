class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.5.tar.bz2"
  sha256 "6f115a095962a4015b5e748feb9e3ac2ee0925ba045dcfac77821acdcbf5f2a2"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any
    sha256 "f827cb24e59d19993240324660355aee3e02416b2ddbde65ebfbc6189b4e18ca" => :sierra
    sha256 "bb3c1c36b791d5e6b3f041d04d5ae63c9cf7ed5f8ac588c310080bb13e0dba3b" => :el_capitan
  end

  depends_on :macos => :el_capitan # needs thread-local storage

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openblas" => :optional
  depends_on :x11 => :optional

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args + %w[-DDLIB_USE_BLAS=ON -DDLIB_USE_LAPACK=ON]
    args << "-DDLIB_NO_GUI_SUPPORT=ON" if build.without? "x11"

    if build.with? "openblas"
      args << "-Dcblas_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib"
      args << "-Dlapack_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib"
    else
      args << "-Dcblas_lib=/usr/lib/libcblas.dylib"
      args << "-Dlapack_lib=/usr/lib/liblapack.dylib"
    end

    mkdir "dlib/build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <dlib/logger.h>
      dlib::logger dlog("example");
      int main() {
        dlog.set_level(dlib::LALL);
        dlog << dlib::LINFO << "The answer is " << 42;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match /INFO.*example: The answer is 42/, shell_output("./test")
  end
end
