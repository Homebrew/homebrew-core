class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.4.7.tar.gz"
  sha256 "6779178aaf2429fe9f848694226eeecc6df4458ca26dd5ee1caa76fc9e3e11ab"

  bottle do
    cellar :any
    sha256 "4fd398f7eee4f84aab35a0adcb4fff189f63efd2b35b0f85d67075e48fff6775" => :high_sierra
    sha256 "6d9450442f80bc905713142d8d97f67f93bd94a464f8fee7d8773fefaf128444" => :sierra
    sha256 "cc2a2d0c0d630290a63d5c46a76af23a8fa5c759133dfe7853160a7356f24db3" => :el_capitan
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
