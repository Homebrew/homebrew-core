class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.5.2.tar.gz"
  sha256 "1fd9023adaf58fece4fce3b8521aca225ef1d1c9a42797cdd1de0b42f2e03abf"

  bottle do
    cellar :any
    sha256 "efbe22c774602006938e70160790d815844c0526b80862b39268cd7a6a551f3f" => :mojave
    sha256 "0fcf5bb9d32dc93cedad3995c5c7b1791807f7aae30b98c3d05e5f82032bac2a" => :high_sierra
    sha256 "abca5d9f2e7ecdbbdbaa1df5f4cc91a12d16829d5db3ea8d1e53cd9fba0d9dd2" => :sierra
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
