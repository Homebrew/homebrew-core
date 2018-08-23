class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  url "https://github.com/flexible-collision-library/fcl/archive/0.5.0.tar.gz"
  sha256 "8e6c19720e77024c1fbff5a912d81e8f28004208864607447bc90a31f18fb41a"
  revision 1

  bottle do
    sha256 "392131d9e9aea1fdd2e727161a7c4909dbe5efad7742e88ccc1afbc9090725bd" => :mojave
    sha256 "72a5ca040739722599576b579a6f864ca3307bf01ad8403765d739813a3e1fd0" => :high_sierra
    sha256 "8fd76b19ab4408397f161947d7da47f619ec710ddcdc2c012579440a6885f192" => :sierra
    sha256 "a2bc2115c9cc18a7f155583e6209ade38e73b80a10704e4d26e44ed177bcf5a5" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libccd"
  depends_on "octomap"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fcl/shape/geometric_shapes.h>
      #include <cassert>

      int main() {
        assert(fcl::Box(1, 1, 1).computeVolume() == 1);
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lfcl", "-o", "test"
    system "./test"
  end
end
