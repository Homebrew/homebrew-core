class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.15.tar.bz2"
  sha256 "5340eeaaea7dd6d93d55e7a7d2fdb1f854a77b75f66049354db53671a202c11d"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "06eacb743295523bce9537ed7cd433dbee4f1879428c627e8fc088fb4ed74fab" => :high_sierra
    sha256 "8413e3d80f805a5e826d564805e249ab449c00813ab5a68b6279858a0fba51dc" => :sierra
    sha256 "abf2ea127674b32fe83097d59b19127948b8824cbb94d7ce307a1035302a2f01" => :el_capitan
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
