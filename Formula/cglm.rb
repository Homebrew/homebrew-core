class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.4.6.tar.gz"
  sha256 "680c7cd7f9ed5f695529fc61cd2bc1bfc4528805cb3ae8290de7d26f33ea32dc"

  bottle do
    cellar :any
    sha256 "c6f11d17fe50104c2fbfd3b3bfb2a16715e84e37c7ee8ec111e8a5cdd9ee2d56" => :high_sierra
    sha256 "6fea3faa0f25d949a0d1f19674dfd10523801575e7068211e0c9114bdafd1621" => :sierra
    sha256 "23d232f82e710a7c882c9be0f3f8d34b3a4949ebc238e7c4df46585a44cb42c0" => :el_capitan
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
        assert(glm_vec_eqv_eps(r, z));
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
