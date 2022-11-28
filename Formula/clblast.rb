class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/1.5.3.tar.gz"
  sha256 "8d4fc4716e5ac4fe2f5a292cca42395cda1a47d60b7a350fd59f31b5905c2df6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4e3241807573e4d558bdf6bef9e04b54fca51d9639fdacb8ae1ae79a43e23565"
    sha256 cellar: :any,                 arm64_monterey: "774f70ba7ac65ec99e8a543ab2dda95acd566e60c423ac23b3e176117ef52664"
    sha256 cellar: :any,                 arm64_big_sur:  "46c2acd40dfdb2cb21f14c80273ef4a2d0f7ecc2d2b107ded0485602d397b42c"
    sha256 cellar: :any,                 ventura:        "106bad69194b2c27ad232b6ec231090a4fc6f82964bd6b9b9264c532db60e9bb"
    sha256 cellar: :any,                 monterey:       "a4f1ee6cca9530e84aa3bc0e409cbca95d633a66187b4e82328dbcf575f71ee5"
    sha256 cellar: :any,                 big_sur:        "f467f40350f3237b105e4cce34403b6f7ab51c7999b60131c9d396bcf7210619"
    sha256 cellar: :any,                 catalina:       "bac255054fb5e7cb3638aca4a7e9c5f961f95b13004ed95500218de50c30c34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e9b336180d53a2756e2bc7f3e64a2e2d8b2c0c50ae1444e7afc78dedb6b9c28"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "ocl-icd"
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
