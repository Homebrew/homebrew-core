class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.20.tar.bz2"
  sha256 "df9aa456ed5e190597fa8dafc1471670ced0128d0f115f2be7677c9c42f4328d"
  license "BSL-1.0"
  revision 1
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any
    sha256 "72c4cead9806e3416452ec0acb918f36428b97368189a85f3074864dec0f7229" => :catalina
    sha256 "7f41f22f65075ff180b306d6e34156d3197a3201cbe862d2fa2ad01d0a70db1d" => :mojave
    sha256 "f7b967654cd3a85d235ca6406f94fa0ee03be8bd8f4e7a77ab306e77c7864ecf" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on :macos => :el_capitan # needs thread-local storage
  depends_on "openblas"

  def install
    ENV.cxx11

    args = std_cmake_args + %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib
      -Dlapack_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib
      -DDLIB_NO_GUI_SUPPORT=ON
      -DUSE_SSE2_INSTRUCTIONS=ON
      -DBUILD_SHARED_LIBS=ON
    ]

    args << "-DUSE_SSE4_INSTRUCTIONS=ON" if MacOS.version.requires_sse4?

    mkdir "dlib/build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
