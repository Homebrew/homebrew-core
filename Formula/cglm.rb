class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.7.4.tar.gz"
  sha256 "550a2fe09c9627189f04ddd83c324bafad3367ddbac9ff6684c2808d067927c0"

  bottle do
    cellar :any
    sha256 "23d9c071c963268c96a6e81327f612283e3dd6b7b3ca7606b37c86471b263602" => :catalina
    sha256 "61ba8b3ad2ff5e0780f9dea7c05853850ff3c410d7556e33a9158b03f439676a" => :mojave
    sha256 "50e8e42dfb6da03557c4d543bf0ecef41cd80b7ca6547a0feb6d9e52a218864f" => :high_sierra
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
