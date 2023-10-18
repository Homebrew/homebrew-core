class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/1.6.1.tar.gz"
  sha256 "e68d026108447cab53cb18d473b4363ab3958d7c8f97c522bbee1651069eec66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "906c1f5103a489eff063656fb0a5622dd16f012a40b66d533ff4d365cb72ad2d"
    sha256 cellar: :any,                 arm64_ventura:  "6e6fa024aeaf31caec71f60262761b7b5417924592cbeee885d2a100389ec4e6"
    sha256 cellar: :any,                 arm64_monterey: "65249a30a77c6759bfb8f06c2668ed32190c90a1ac03ccb93e807b6cfbf43c98"
    sha256 cellar: :any,                 arm64_big_sur:  "4593bc3935692822dc01dee7b1a4f0de3541b3cc7f30848a8cb0abeb44069964"
    sha256 cellar: :any,                 sonoma:         "ea63588b783a097e6705d4b00e7738d155622034299b05877b4c7dcdd9c8e96d"
    sha256 cellar: :any,                 ventura:        "bf75f1b66d72f1288fbf51c0fe4eb97a05383314f9f62e449a35e697d41400f9"
    sha256 cellar: :any,                 monterey:       "bb5eba30ceb408c69155a6373b6bc1a28cf7ad5ac76909afdff7f4ef7c8dd1ce"
    sha256 cellar: :any,                 big_sur:        "aaddf71aa357c3905415e59272102d4b45085ca4eee66e050f71ce5ebd6e1437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3327938fa465f3bd86ef8b91fdbadf490deeeacc698ba2ea72fa9452a5ef390"
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
