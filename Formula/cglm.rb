class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.7.7.tar.gz"
  sha256 "2614a61cafc5d2e908364795943b9eebc8be3231128e4c77498e9c3448d365cc"
  license "MIT"

  bottle do
    cellar :any
    sha256 "18cf9782cf75ebdc4d423057e0605a5a8d57e2080f84298fac85bf1b70068093" => :catalina
    sha256 "7504808ad03525e498eaff6a1fb2bb90beb39e811b16ea2a083aacadfac30e28" => :mojave
    sha256 "c37a69d3ce1f4ecc868b1f88f66fb2d6e784e412953b579045cdea3b2d9c8f58" => :high_sierra
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
