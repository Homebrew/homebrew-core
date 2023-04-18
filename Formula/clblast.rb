class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/1.5.3.tar.gz"
  sha256 "8d4fc4716e5ac4fe2f5a292cca42395cda1a47d60b7a350fd59f31b5905c2df6"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4f55526aacc0442025da1267b0860426ad84647379c925444ef551899377464"
    sha256 cellar: :any,                 arm64_monterey: "064a719bd35eb62b2f6504ebfb344f515f846d16c4082c7806ecaa90a2d965f8"
    sha256 cellar: :any,                 arm64_big_sur:  "ba00b33f82f0a675584e82aa1f307f3cd96b6651552dbb9eb18005291ef01aa9"
    sha256 cellar: :any,                 ventura:        "1129b3155dca40e0dde87642e7ed90f6190d69011bb426f143400a35c950b575"
    sha256 cellar: :any,                 monterey:       "05a8d90c678a412691d2c4cbeef4a7ecc0395a25b55b5ad7e80e473826882a17"
    sha256 cellar: :any,                 big_sur:        "338dee181a49007f91a7cbf2ce04369ee71699d9072236bf313cebf86e190f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae7a1cd5c58682516f646142d867e40a5fd6e8d568872a84d12c4cfd268de03"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "make", "install"
    pkgshare.install "samples" # for a simple library linking test
  end

  test do
    opencl_library = OS.mac? ? ["-framework", "OpenCL"] : ["-lOpenCL"]
    system ENV.cc, pkgshare/"samples/sgemm.c", "-I#{include}", "-L#{lib}",
                   "-lclblast", *opencl_library
  end
end
