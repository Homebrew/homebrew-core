class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.12.tar.bz2"
  sha256 "e6a9a20e8350b237e0bc0a8dbc6cb75714f8358e86e7964b5ad8b551f6eb8fef"
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c4d49dd0e8726979f1a2caed12518f2ca8878bf91db5afdf96ad8922eb73084" => :high_sierra
    sha256 "3cd72676d90e98b601ac293645c3ac434fc6b34b4322ed05cf2a6589face262c" => :sierra
    sha256 "f4634700a98a7efff7ec09df57687ab4b601ee8dba85b2a4b24add00e965ee4e" => :el_capitan
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
