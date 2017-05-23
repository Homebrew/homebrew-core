class Libccd < Formula
  homepage "http://libccd.danfis.cz"
  url "https://github.com/danfis/libccd/archive/v2.0.tar.gz"
  sha256 "1b4997e361c79262cf1fe5e1a3bf0789c9447d60b8ae2c1f945693ad574f9471"
  head "https://github.com/danfis/libccd.git"
  revision 1

  bottle do
    cellar :any
    sha256 "d23aeb24c111b74c1fa0bd0baddecdae3cf47e8e1a4c90e84373f7d5f2ef5ffe" => :el_capitan
    sha256 "336624be19dfcd178a5ca2aaaeaf2ac959c50cb3acd2e5239a00d204a232b553" => :yosemite
    sha256 "9ad6f74a1906d1bbfbc9730a48736f453d016464c977432d0101ae4bc357bc93" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
