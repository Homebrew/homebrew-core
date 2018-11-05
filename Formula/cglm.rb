class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.4.9.tar.gz"
  sha256 "5a0b486042e4e898ac326f96f6680c23a8872ae8ae9446d1b22cf2ced613ebc2"

  bottle do
    cellar :any
    sha256 "251902ea18fbdc5ad90e86ac4192fc8a9aa7b2ff3c506f72c35800e6c53c2242" => :mojave
    sha256 "c732bf07255beeaff56a0a7d76aeef275436d22ae1674913631ef4e8c686d826" => :high_sierra
    sha256 "67cf274c912f9165266258667139d8cd5ba423426b2a0a4b0028dfe6cf62e7d8" => :sierra
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
