class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/1.4.0.tar.gz"
  sha256 "fbdb7eab9a58aa59137a3fc9bebe2288e7ddd8f8afd5e5658c6bff6ddc9349eb"

  bottle do
    cellar :any
    sha256 "8254e3e21d6633170743bf46b035a00df6139ce0181ca58613fbea88b44dd1e6" => :high_sierra
    sha256 "a80742b7dceee1d82f82b038138bf0a66844b11e67861405faa4999140f689d7" => :sierra
    sha256 "6f1ceb76dd369fb8129c8ec252b2c8a54c95572e6e3d02d8df758296ba47e062" => :el_capitan
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
