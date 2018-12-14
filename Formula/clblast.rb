class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/1.5.0.tar.gz"
  sha256 "b3198d84d175fd18b0674c0c36f5fb8b7c61a00662afb8596eb5b0b9ab98630c"

  bottle do
    cellar :any
    sha256 "f20a3597fad8e473be217855bab1aa603c1f7ebb68bb66d8d50dc331d5bf998c" => :mojave
    sha256 "bc1bc4fd8d0be7b9c40f21fefe5c44967ca331cd620dca30082907832f6f6f3b" => :high_sierra
    sha256 "f58bea47c9b7528ea31a6cc1edd5c9477c93db3e97519eeb817fb00df9e92bfe" => :sierra
    sha256 "b9d7b07467472a20e1fa1a914d9272e93eb5f21ccaeb3603ab03e52bfdf44182" => :el_capitan
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
