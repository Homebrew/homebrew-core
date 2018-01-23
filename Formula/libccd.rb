class Libccd < Formula
  desc "Collision detection between two convex shapes"
  homepage "http://libccd.danfis.cz/"
  url "https://github.com/danfis/libccd/archive/v2.0.tar.gz"
  sha256 "1b4997e361c79262cf1fe5e1a3bf0789c9447d60b8ae2c1f945693ad574f9471"
  revision 2

  bottle do
    cellar :any
    sha256 "19f4a01a759eccc1f70a5d997ac19c9cfbd7c981d02191a1c20ec196de650cb6" => :high_sierra
    sha256 "c1caf2e2d4040fcf1ae219e41040bad0f4f2d2ca6969419f01da8969ce93afc8" => :sierra
    sha256 "39911fefe6532ef6d390837a087cf46bd16af36b849f737c3a2e689a3908334a" => :el_capitan
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
