class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.4.5.tar.gz"
  sha256 "3fd14f71477a4976ed9cd058d096de6c49b524d02cbcadc27c5a2fdba0ed1f09"

  bottle do
    cellar :any
    sha256 "ff26619caecd2eacae903fc277490a08f21fae3343c53d87b9b616e7fbab3a42" => :high_sierra
    sha256 "f735d214e24036ef585d636bdd74e78b7112a52339c61175c48876ed52d0221e" => :sierra
    sha256 "d5d40f046cc551cfeffe575582d8212d113035d2cd37ae8112ae38d5fd8e9ad8" => :el_capitan
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
