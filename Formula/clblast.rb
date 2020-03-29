class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/1.5.1.tar.gz"
  sha256 "1679843290efdeafdc187c07dc033e27067b37e34243f9417087700f61408069"

  bottle do
    cellar :any
    sha256 "e1908450ec5ca862fc49fd80a2c33565729187372749e395a88baa49371465e5" => :catalina
    sha256 "b6b81483ab6621bb1a9002e771c50d8fa90364b39aabe293dc276991ab5e60b5" => :mojave
    sha256 "d4fc7ec77ca33d0d8182e345000044a925128ffdbc39f7e0802c8500475007c8" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "samples" # for a simple library linking test
  end

  test do
    system ENV.cc, pkgshare/"samples/sgemm.c", "-I#{include}", "-L#{lib}",
                   "-lclblast", "-framework", "OpenCL"
  end
end
