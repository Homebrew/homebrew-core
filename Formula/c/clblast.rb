class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/refs/tags/1.6.2.tar.gz"
  sha256 "d7c1fb61162a6e2fa4eb6e95fafacbe22ee8460cd82371478f794f195aad267f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ebca10ae7272196af10cf453e7ad120674926db5941f9f8b4017ec90436b0064"
    sha256 cellar: :any,                 arm64_ventura:  "61b3c32e0d3f4953a5c1e2606f685c6656fafe3ac68eaef6a60605d36d98b655"
    sha256 cellar: :any,                 arm64_monterey: "e91a630c1b4e3e753fd5c73c202f36c05dea759f8e1e5e8f0c8867a89d36b3bc"
    sha256 cellar: :any,                 sonoma:         "938856dc505d77f6a0651ba67db9b0ae2ace4232187d9a2e1346f7bdaaf5e597"
    sha256 cellar: :any,                 ventura:        "125f99f8188915d70ea3e7f7ae96ca0406b47c2c8e1341eca5d2d13f8d1c6dc1"
    sha256 cellar: :any,                 monterey:       "fc7669fd1db375c8705b33b2300abb1af4b826e504ea708e48d5ecf9f427c67d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9911067b1bceff5bac59df3ecbbc4becdc96ed0639a9116b6ad56392fb118c0"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "samples" # for a simple library linking test
  end

  test do
    opencl_library = OS.mac? ? ["-framework", "OpenCL"] : ["-lOpenCL"]
    system ENV.cc, pkgshare/"samples/sgemm.c", "-I#{include}", "-L#{lib}",
                   "-lclblast", *opencl_library
  end
end
