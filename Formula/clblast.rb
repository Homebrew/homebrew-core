class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/1.5.0.tar.gz"
  sha256 "b3198d84d175fd18b0674c0c36f5fb8b7c61a00662afb8596eb5b0b9ab98630c"

  bottle do
    cellar :any
    sha256 "8044e1c69fa9f1ec704c04913d4fbaafa07538cb80e929a1f4845aa471730d2d" => :mojave
    sha256 "4bc63e9ac1f49a693fcb0d69eaa755549c2c29feac5c40a216b43a1b78100848" => :high_sierra
    sha256 "7948c069f411f9d3c96aff149a76b7d8b41ae583b9a54a423ebab84275a58f5b" => :sierra
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
