class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.20.tar.bz2"
  sha256 "df9aa456ed5e190597fa8dafc1471670ced0128d0f115f2be7677c9c42f4328d"
  head "https://github.com/davisking/dlib.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "09f8fd001b126737e4389e4700cbd2c5954a5f14f1dc3608ef467e5ca89539d8" => :catalina
    sha256 "9994a81f7d7d595faebd25b57a8864ba50bb7428e01be8e3462670dd26041a72" => :mojave
    sha256 "509e70a5a60b1752df38f1ebb9d9fc747bcc7c1738c8c8616246c4f22bb65d99" => :high_sierra
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
