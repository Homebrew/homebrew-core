class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.5.2.tar.gz"
  sha256 "1fd9023adaf58fece4fce3b8521aca225ef1d1c9a42797cdd1de0b42f2e03abf"

  bottle do
    cellar :any
    sha256 "91086beaccfc748dac69196aef01e950cafc625e78d495928e27aec5da7b96ed" => :mojave
    sha256 "184d8201e30f3971d67182022c49ca29d60b9135dba6efb25dbc168b9a2d4b2a" => :high_sierra
    sha256 "15e03edbf21b61bf283c74cb5ed81bb0778c56288e422eb128077ac6ffb17717" => :sierra
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
