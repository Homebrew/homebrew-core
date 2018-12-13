class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.5.0.tar.gz"
  sha256 "b72cdbb23ecb3cb4fe7025c1eb5293c497aea813323c89435bd2d9e8fd2fad17"

  bottle do
    cellar :any
    sha256 "6b3a6b85a94727680ab0642241ebe7c18c5ea1b17e59147d6a136a647c603525" => :mojave
    sha256 "2f975905ad30775b8313afe4500d6582f64476e9c81a00b671c17b706155de63" => :high_sierra
    sha256 "a44680b7d3f7908f653c7ebc1bfe9a504f34832e1a189650e5d560ec66158209" => :sierra
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
