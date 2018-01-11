class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  url "https://github.com/flexible-collision-library/fcl/archive/0.5.0.tar.gz"
  sha256 "8e6c19720e77024c1fbff5a912d81e8f28004208864607447bc90a31f18fb41a"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libccd"

  def install
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

    system ENV.cc, "test.cpp", "-std=c++11", "-L#{lib}", "-lfcl", "-lstdc++", "-o", "test"
    system "./test"
  end
end
