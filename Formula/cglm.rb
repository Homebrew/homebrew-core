class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.6.0.tar.gz"
  sha256 "fa6de3affdd912430a124463c647e2b933570179759366958af856c6c0fe25ca"

  bottle do
    cellar :any
    sha256 "f2d505388de91d5e39a6b8bdd8b111bcec205eb6233e31c828961006f47824e4" => :mojave
    sha256 "5832844b2f1c092bcf7858b3d2f001ee6c95c93fbbac2fa2a90faa4637e57df6" => :high_sierra
    sha256 "d96cad0365653f84496ba57bd460225b14030a99057a510db83d0be0eaecb864" => :sierra
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
