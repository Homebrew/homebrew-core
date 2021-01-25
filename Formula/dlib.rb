class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.21.tar.bz2"
  sha256 "be728a03ae8c4dc8b48408d90392a3c28bc6642a6eb22f3885895b434d7df53c"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "655d96ba94159cd7a80ff842ea8693aa7857e91496a8447b3df23ddf50ee0993" => :big_sur
    sha256 "81dc4133691925848cc96ccaac3158456d47544a0614b35c29a9948f7faef10b" => :arm64_big_sur
    sha256 "597a1595ee2f5071afcac72128f85b3aadda96002253e54ae16995e151fb5432" => :catalina
    sha256 "52ab2f5e4073682520ec0f5cf7410bad8f1a03a4e783bdc4a93d1372cacee808" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openblas"

  def install
    ENV.cxx11

    args = std_cmake_args + %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib
      -Dlapack_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib
      -DDLIB_NO_GUI_SUPPORT=ON
      -DBUILD_SHARED_LIBS=ON
    ]

    if Hardware::CPU.intel?
      args << "-DUSE_SSE2_INSTRUCTIONS=ON"
      args << "-DUSE_SSE4_INSTRUCTIONS=ON" if MacOS.version.requires_sse4?
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
