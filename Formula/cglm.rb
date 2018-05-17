class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.4.5.tar.gz"
  sha256 "3fd14f71477a4976ed9cd058d096de6c49b524d02cbcadc27c5a2fdba0ed1f09"

  bottle do
    cellar :any
    sha256 "7939f73390ce28ed5427357b0a295eb280c56ce84ca6ecc51446e3c6b8f2c80d" => :high_sierra
    sha256 "638911a86d22630770d5e0a5ec75a44cf3720a774035349058ff879829c2082d" => :sierra
    sha256 "182ebed03dc3fb5e1157d764af02fa810d2a7be4f608edaaf989c099616e7c28" => :el_capitan
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
