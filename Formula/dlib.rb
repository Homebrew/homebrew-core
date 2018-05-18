class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.11.tar.bz2"
  sha256 "3acb7525d25f445b3f8bc33ebe46f056297cc97c635abf275e6c0e7ca09ef48b"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fa2420f3819ada19ec84bafa18aeee4e78813a3436057b7a0f7091424ee6dc3" => :high_sierra
    sha256 "3df41ce3f850258b9a5e85be484e63b8c5ce37ddc8f2312feb3141142ed0f406" => :sierra
    sha256 "7c4601db243f150813f21135c295c6b1aabaad48e7cc89a20fc41e9d060299c4" => :el_capitan
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
