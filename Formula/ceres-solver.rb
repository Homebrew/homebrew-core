class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.0.0.tar.gz"
  sha256 "10298a1d75ca884aa0507d1abb0e0f04800a92871cd400d4c361b56a777a7603"
  license "BSD-3-Clause"
  revision 4
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1b729631e1d4e35fa8cdb4e38daeab4db1900273bb3b3a97800d6609c9048011"
    sha256 cellar: :any,                 monterey:      "e331ba4a260953f79cc693e323515cd11047e181c104affded4e9c60a93fd3f7"
    sha256 cellar: :any,                 big_sur:       "ae150dc0c639a5e4efdbd7bf2f01c933f9852a20f78056670eb5b27fe3bc28f0"
    sha256 cellar: :any,                 catalina:      "de7e1776beb556708bfb34af3b1e26f67ce5f9ecfb7e4332a56d25c456e01082"
    sha256 cellar: :any,                 mojave:        "c7d6078d42b69ebc67ef7e2ed8cabcc9cbcfb32f0509a2a20f869fe627b1f53d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af15dc42554f737ec56596c94232ff83d8eb546bb6bf8bf5af352887f1b1340f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

  # Fix compatibility with TBB 2021.1
  # See https://github.com/ceres-solver/ceres-solver/issues/669
  # Remove in the next release
  patch do
    url "https://github.com/ceres-solver/ceres-solver/commit/941ea13475913ef8322584f7401633de9967ccc8.patch?full_index=1"
    sha256 "c61ca2ff1e92cc2134ba8e154bd9052717ba3fcae085e8f44957b9c22e6aa4ff"
  end

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DLIB_SUFFIX=''"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "data"
    doc.install "docs/html" unless build.head?
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
