class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  url "https://github.com/flexible-collision-library/fcl/archive/refs/tags/0.7.0.tar.gz"
  sha256 "90409e940b24045987506a6b239424a4222e2daf648c86dd146cbcb692ebdcbc"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/flexible-collision-library/fcl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0ab8eb79ee5ae022e186975198bd18da7cde25c41cb9e52e70366bf20de59e48"
    sha256 cellar: :any,                 arm64_sonoma:   "6a4d2a1e04f17fb6cf2d7ed92524f09a841c3b212f3ecf22d9dc00dd294bb895"
    sha256 cellar: :any,                 arm64_ventura:  "d147e210255b79430e8fed2455325c53aa0975c2f081b39c44050c5921efd813"
    sha256 cellar: :any,                 arm64_monterey: "05d4d212709bccf7dc0f78eb01882937cdfa656ee019b47493baf6c404d33359"
    sha256 cellar: :any,                 sonoma:         "24a08459f44fe31c2021fe74d4e3cc05dbc32141ad8d941e60c60863229e6635"
    sha256 cellar: :any,                 ventura:        "06b3d235437c8047c3aa7d3951e15e254a6a81dc45546fb34d8732ddeaac68ba"
    sha256 cellar: :any,                 monterey:       "199ee80d6917e61d200cb4ce8fd9516542270ce9eefdfb3139d98f203251fade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5840ff43dc2df33f18284bf49f0c29c254d5993d71da5d9939bb18ce316da35d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "libccd"
  depends_on "octomap"

  def install
    ENV.cxx11
    system "cmake", ".", "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fcl/geometry/shape/box.h>
      #include <cassert>

      int main() {
        assert(fcl::Boxd(1, 1, 1).computeVolume() == 1);
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}",
                    "-I#{Formula["eigen"].include}/eigen3",
                    "-L#{lib}", "-lfcl", "-o", "test"
    system "./test"
  end
end
