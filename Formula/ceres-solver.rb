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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "4854064146581d467e76483acf43e32cac3870cd0d9d12b7ac2bf7b3b7924806"
    sha256 cellar: :any,                 arm64_monterey: "8853908633eb208b01f8c837f25f21d26e7ab25467989a1e41d8fb169818a9e3"
    sha256 cellar: :any,                 arm64_big_sur:  "c2248770066bdb4efaed2e8cdd28665d2b250b0f22323e3fb081e78ebfc5e558"
    sha256 cellar: :any,                 ventura:        "c79050cc85fd6502a13f1b6077cd0bf570a908b3cd4890cc990ffce16dff4e5f"
    sha256 cellar: :any,                 monterey:       "5ec1c84cbbae986126cb0876f46bd74621ff9b1a562ac60e5ae4bcc69c893468"
    sha256 cellar: :any,                 big_sur:        "4904e364045a99496a2a299221b4a333088a988265cca04af91c05df89c8091a"
    sha256 cellar: :any,                 catalina:       "ad19523c11bb9c90599c32ac22af103a96b29b77b046065fd1cc3c93c518e419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7039f64b965c7c0f5e028da2a445b9a98dd80c043bb6b2257675c839a3d146"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

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
