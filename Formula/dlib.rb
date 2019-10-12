class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.17.tar.bz2"
  sha256 "24772f9b2b99cf59a85fd1243ca1327cbf7340d83395b32a6c16a3a16136327b"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f25e58d6390fc91a6d1cb279a7b55650b2e9c5053566ad726a917513a5ec4a85" => :catalina
    sha256 "4bd4f3e8c88afa3a8148581809572d0507d05ceba9589ce6415bf27a6796779d" => :mojave
    sha256 "2837e63fbd1eaf70c64ebda344bb149404fbec3010f3aa3cbabbeba69c565735" => :high_sierra
    sha256 "458f053b009f40e0175ae2be5df8caa40672ab81a09af725d6ab7fd15b1e9dae" => :sierra
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

    if MacOS.version.requires_sse4?
      args << "-DUSE_SSE4_INSTRUCTIONS=ON"
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
