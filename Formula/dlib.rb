class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.16.tar.bz2"
  sha256 "37308406c2b1459a70f21ec2fd7bdc922277659534c708323cb28d6e8e4764a8"
  revision 1
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7793a79b6d155fce278f2d4aef97b248bbad453776f07798f2344deb4a1243cd" => :mojave
    sha256 "e7c5d7b023879adb58be981d34041b3b5037292c180b711edd7c0b4eca7e61fe" => :high_sierra
    sha256 "c20e7bcd027a030f32ab473a400ea39b1971e1e006465494a93bb333f12a6e91" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on :macos => :el_capitan # needs thread-local storage
  depends_on "openblas"

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args + %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib
      -Dlapack_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib
      -DDLIB_NO_GUI_SUPPORT=ON
      -DUSE_SSE2_INSTRUCTIONS=ON
    ]

    unless build.bottle?
      args << "-DUSE_AVX_INSTRUCTIONS=ON" if Hardware::CPU.avx?
      args << "-DUSE_SSE4_INSTRUCTIONS=ON" if Hardware::CPU.sse4?
    end

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
