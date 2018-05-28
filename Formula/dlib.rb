class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.13.tar.bz2"
  sha256 "fe90b94677f837c8f0bcb0bb450b313a422a9171ac682583a75052c58f80ba54"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e834acd2a9694a54b32efb029119301f4d2e74317219333ab6e05964b6c9923a" => :high_sierra
    sha256 "1fe9ecfb70229631a11e5ad4d75018e49ba13b9b6c6f10662f739d968ee4cbd3" => :sierra
    sha256 "38803c09e00859a5f44f9eccad44070ee461213b98e543f759fdf9477c2d6016" => :el_capitan
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
    args << "-DUSE_SSE2_INSTRUCTIONS=ON" # SSE2 is present on all modern macOS hardware

    unless build.bottle?
      args << "-DUSE_AVX_INSTRUCTIONS=ON" if Hardware::CPU.avx?
      args << "-DUSE_SSE4_INSTRUCTIONS=ON" if Hardware::CPU.sse4?
    end

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
