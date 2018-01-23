class Libccd < Formula
  desc "Collision detection between two convex shapes"
  homepage "http://libccd.danfis.cz/"
  url "https://github.com/danfis/libccd/archive/v2.0.tar.gz"
  sha256 "1b4997e361c79262cf1fe5e1a3bf0789c9447d60b8ae2c1f945693ad574f9471"
  revision 2

  bottle do
    cellar :any
    sha256 "042f76f2faba70f4afd7772865014acf1e18b4596e55cbca4be4414bfdd7d7c5" => :sierra
    sha256 "73dc3083059a205688fc3edf3c49a5277fdb3566b0d0a2e3217d43b79b14093c" => :el_capitan
    sha256 "52cc90f9245c514ab30cf1b5d5af292dfd014c804556b0fd0f07afe431c7bf87" => :yosemite
    sha256 "fae18bcb83cdca783aecb9084fea2803cf60a79a8c46a409c2ee6b94505dfee4" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DENABLE_DOUBLE_PRECISION=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ccd/vec3.h>
      int main() {
        ccdVec3PointSegmentDist2(
          ccd_vec3_origin, ccd_vec3_origin,
          ccd_vec3_origin, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lccd"
    system "./test"
  end
end
