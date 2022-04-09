class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.1.0.tar.gz"
  sha256 "f7d74eecde0aed75bfc51ec48c91d01fe16a6bf16bce1987a7073286701e2fc6"
  license "BSD-3-Clause"
  revision 1
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2e9c1240a5b9d5bbcce551f111eae6bc3a7d98198067843fcded1b05100be07"
    sha256 cellar: :any,                 arm64_big_sur:  "d714e1ec79e261c0f35f9c2979b0a58b39653569255e479bf163f049d79f945c"
    sha256 cellar: :any,                 monterey:       "507a49279c164dbbe7a7f22a745c767b9e6fbe4badf5215568ee962e712ec92a"
    sha256 cellar: :any,                 big_sur:        "ae18afa42ca071eee949d429aff357f227958a3c3dea55a6f32e4310e8940b80"
    sha256 cellar: :any,                 catalina:       "3b223b58b5a5a2473e577070bbc82042859daa3cba6ba6096ac0d4a20e28fd88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5e36f4daad9f0cd3545eb5abadeae53c757e2c254c127aa093859f6059ad125"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DLIB_SUFFIX=''"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "data"
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(helloworld)
      find_package(Ceres REQUIRED)
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld Ceres::ceres)
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld")
  end
end
