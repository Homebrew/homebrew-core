class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  url "https://github.com/flexible-collision-library/fcl/archive/0.5.0.tar.gz"
  sha256 "8e6c19720e77024c1fbff5a912d81e8f28004208864607447bc90a31f18fb41a"
  revision 1

  bottle do
    sha256 "9339278a609d8fbcd24f911eafc78e580c965cd6159229eab12ded553c92d7d3" => :high_sierra
    sha256 "bb60099d73cf3c322cb1453c735d3305fdc652b068bbd220c25f565ec825b537" => :sierra
    sha256 "b93f6cf2087e3c9a1dbbca8552ff5b01913f229d3bfb4968490386fb0348f3ad" => :el_capitan
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
