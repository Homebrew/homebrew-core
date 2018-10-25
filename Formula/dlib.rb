class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.16.tar.bz2"
  sha256 "37308406c2b1459a70f21ec2fd7bdc922277659534c708323cb28d6e8e4764a8"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fea59bd6ec83be1bece0a71a691caa565403f33979aaa10dd2d84f3ff817caac" => :mojave
    sha256 "0f87f8f25d8b27daa2bc02094402b120f4a7aa3aa3610a66c2cc9760eadb081f" => :high_sierra
    sha256 "c748860e5d6ad042afbaacb07749d32f0a287ae2fe4097cf13f29fd8ea65cdeb" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on :macos => :el_capitan # needs thread-local storage
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
