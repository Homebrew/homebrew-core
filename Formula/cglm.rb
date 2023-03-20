class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "9561c998eb2a86dca5f8596b5cd290d76f56b7735c8a2486c585c43c196ceedd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "09c64c92b8fbc14122e7696c007fbad165c4d2122212e97b0522cb10c3ad7bf9"
    sha256 cellar: :any,                 arm64_monterey: "67043e337087d9a3cdfac5f86486dbd31725eee1caaa9d7a7130b846d1c4d13f"
    sha256 cellar: :any,                 arm64_big_sur:  "f556d15cf860255714192580d60330541dbd41328449771f875e620f34b7a29b"
    sha256 cellar: :any,                 ventura:        "a555f5ff395baf7f7f619876ac66c07b1455e68aad04e68ca8ecb26944b5885a"
    sha256 cellar: :any,                 monterey:       "e0fdda10593638d07a408e62077683833f62bb21750221d87c1d992877ac8a50"
    sha256 cellar: :any,                 big_sur:        "c54a77111cb737885398fc2fdf36374f3a3cce685085f798f0b63f73cb1503d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4dd1386e5fff49160975443f9c9931c8e3c280356646b1a0ac74c5f20e43a70"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cglm/cglm.h>
      #include <assert.h>

      int main() {
        vec3 x = {1.0f, 0.0f, 0.0f},
             y = {0.0f, 1.0f, 0.0f},
             z = {0.0f, 0.0f, 1.0f};
        vec3 r;

        glm_cross(x, y, r);
        assert(glm_vec3_eqv_eps(r, z));
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
