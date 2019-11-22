class Libccd < Formula
  desc "Collision detection between two convex shapes"
  homepage "http://libccd.danfis.cz/"
  url "https://github.com/danfis/libccd/archive/v2.1.tar.gz"
  sha256 "542b6c47f522d581fbf39e51df32c7d1256ac0c626e7c2b41f1040d4b9d50d1e"

  bottle do
    cellar :any
    sha256 "d243743b0d6962d55961bdda60fe8ea32bb738dea0509930d5d4114db2d52013" => :catalina
    sha256 "05c8005ed028e5d5ca250aba9f3c69ece3af5766d91c68fa50fbcf78d139849d" => :mojave
    sha256 "3b0a74f46d98cc57ddbff8c4f37227e8c5f528905037f346bf17104ba17b71f7" => :high_sierra
    sha256 "63e2b6149dea77e8ece7a88f7f5f941d9606e9843bc46e4a48853858f6b4a7b3" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DENABLE_DOUBLE_PRECISION=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <ccd/config.h>
      #include <ccd/vec3.h>
      int main() {
      #ifndef CCD_DOUBLE
        assert(false);
      #endif
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
