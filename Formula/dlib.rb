class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.15.tar.bz2"
  sha256 "5340eeaaea7dd6d93d55e7a7d2fdb1f854a77b75f66049354db53671a202c11d"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b46587048748fd3612b11ad947af43da6fa5a56b3b7b49795eba6473d52093a2" => :high_sierra
    sha256 "f41623ee7575269bb09123a23b46795979a5b2b1e74cdca37c24341dd5858a3a" => :sierra
    sha256 "828d6e762e3c39c4efff6d7b5f32da406bac2d8bc710ebef791b728e3d27f06f" => :el_capitan
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
