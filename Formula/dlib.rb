class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.21.tar.bz2"
  sha256 "be728a03ae8c4dc8b48408d90392a3c28bc6642a6eb22f3885895b434d7df53c"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any
    sha256 "e2d4bb20a24df712a73fc74c162851dbfededf25391e4ae002858d705cbfb112" => :catalina
    sha256 "58ad454876f4a987a8fff1df2fc5f7e04693a19cb0ece79eaa7ffb2dcdf18c36" => :mojave
    sha256 "c34bb491a71eb49ab4eb9af3dd18d2c8557f9f06b14b55b08aa8ed7d3cf6945e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on macos: :el_capitan # needs thread-local storage
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
