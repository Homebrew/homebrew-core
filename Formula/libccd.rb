class Libccd < Formula
  desc "Collision detection between two convex shapes"
  homepage "http://libccd.danfis.cz/"
  url "https://github.com/danfis/libccd/archive/v2.1.tar.gz"
  sha256 "542b6c47f522d581fbf39e51df32c7d1256ac0c626e7c2b41f1040d4b9d50d1e"

  bottle do
    cellar :any
    sha256 "2940a850669c09d0cf91c156ef8ad0bbf7d3706c9e3584d84ac0afedab457c05" => :mojave
    sha256 "16412e782ac7bf2b0b488e495189663b75e04fdd51156c389ff580e7757f55d5" => :high_sierra
    sha256 "0bc8ed0f2e20d71f778dbf23a01fec029685f444eb4c50b9eaf7144ef907126b" => :sierra
    sha256 "506cfff7d53b7ad38174f240d156e46d0a79f336f859e5c8faca03e68b2a850b" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DCCD_DOUBLE=ON", *std_cmake_args
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
