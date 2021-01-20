class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/1.5.2.tar.gz"
  sha256 "ad804ec228100bd5a329a9dcd88d987e70b93c9fd714bb2b3dce6cf016b8c8e9"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "011236dce7c79bbe239feb3d23db5614ced6ff55de8c2e284de2ea067e9e76ae" => :big_sur
    sha256 "d0c66aca34c66fe7c62a485ca1eeaf24f5f36d840c62669f6bbf904750b7e10a" => :arm64_big_sur
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
