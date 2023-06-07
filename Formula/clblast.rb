class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/1.6.0.tar.gz"
  sha256 "9bff8219f753262e2c3bb38eb74264dce8772f626ed59d0765851a4269532888"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "984d844bdc03123f638562dcd5635273aa7958f5c87094fc1665cfc09fe58033"
    sha256 cellar: :any,                 arm64_monterey: "47f65ede3f5843e7ac0d1bee7ae5d4918dad0ba1b614da58d8b249cef34e063b"
    sha256 cellar: :any,                 arm64_big_sur:  "a15b25ff7e116cfcd7d43d859d28f6cac83d8b4d7d4796611b740df0e66a122f"
    sha256 cellar: :any,                 ventura:        "d16057ae19dfdcec70f091bd10614aa47e755659d0e4076c19f44e17f7a0f10d"
    sha256 cellar: :any,                 monterey:       "8b7cc06ecf7305696bcbcee8452552f9388092520a0b17598b8923f41423ceb3"
    sha256 cellar: :any,                 big_sur:        "1c3099b64b32902e513b27176d5b2fa172ce5ff6ffc975c929efbed522c5c512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "955281c8203618c4d2a884a2597635956ad3d9af0a5a23cdfc41753831f2da89"
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
