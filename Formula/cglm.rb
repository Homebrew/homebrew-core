class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.7.2.tar.gz"
  sha256 "c64083298590a244cbc648f578cb75adee2b8d23cb817df5dab5cde09eb8a8ba"

  bottle do
    cellar :any
    sha256 "e3ee844dd6ee90eef23ad9bab0bf7b27ddd14673a861f997f564f7af29f67cc5" => :catalina
    sha256 "c32e801f823de46bf1d72e711a5922eeef50d8b9832fcadc4d5aea616aadcb8d" => :mojave
    sha256 "fd6887d4d8f6810490e6486ed6c8f706020f3bb11bcf7cedbb846cb05bd8ac4a" => :high_sierra
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
