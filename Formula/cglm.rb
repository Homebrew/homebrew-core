class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.6.0.tar.gz"
  sha256 "fa6de3affdd912430a124463c647e2b933570179759366958af856c6c0fe25ca"

  bottle do
    cellar :any
    sha256 "764a17390d412ba15ba263d6143a3f2e722e25ce1045ac061ae3bb4398153857" => :mojave
    sha256 "5d0c188bfaeddbe9e7233cd90c52b3d7cc9364a60b2d3773c88c6c03d5fe6c19" => :high_sierra
    sha256 "07c46eea64f6074f31ae21253363322ac0f01217a10998fa412cfcce56744c06" => :sierra
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
