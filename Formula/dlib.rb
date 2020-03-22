class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.19.tar.bz2"
  sha256 "1decfe883635ce51acd72869cebe870ab9b85eb094d417adc8f48aa7b8c60cd7"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ae2a8809bfe9eb63be8ec74adb0be4d84a84b80d6e31b090d7c17537b0adf12" => :catalina
    sha256 "8eff561df45210fe1a71101d62ecd8b3ae1055d49e7c0442735b60bffe4dc034" => :mojave
    sha256 "394c9aeeb51f9fa1c0cc5fc3b8343e42a3b439e27ac1a938c0d993bb6a0712eb" => :high_sierra
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
