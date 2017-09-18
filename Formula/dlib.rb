class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.7.tar.bz2"
  sha256 "825dbe45e0d379a4e5584c2918b1e0cb37e9ed75657766fd7b2b4f3e05f892d6"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any
    sha256 "4a454baa4e26d2e824c65d555edcf3f6e9b51713fbf4690b054482f6bdb46d5b" => :sierra
    sha256 "3f1430496a2c1beca938d91e3dffec345baa3e0688ff092f3deec30de539b875" => :el_capitan
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
