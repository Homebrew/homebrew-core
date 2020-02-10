class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  url "https://github.com/flexible-collision-library/fcl/archive/v0.6.0.tar.gz"
  sha256 "6891abac5cc26d64f5ef8894bc6c2a30174558c5c83a3ed63cf65a21cb619b2b"

  bottle do
    sha256 "07ef96db4ac5806832c2e6bd28eba505c98c1bb55ed1f86d6d1793752b9265c4" => :catalina
    sha256 "392131d9e9aea1fdd2e727161a7c4909dbe5efad7742e88ccc1afbc9090725bd" => :mojave
    sha256 "72a5ca040739722599576b579a6f864ca3307bf01ad8403765d739813a3e1fd0" => :high_sierra
    sha256 "8fd76b19ab4408397f161947d7da47f619ec710ddcdc2c012579440a6885f192" => :sierra
    sha256 "a2bc2115c9cc18a7f155583e6209ade38e73b80a10704e4d26e44ed177bcf5a5" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "libccd"
  depends_on "octomap"

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
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
