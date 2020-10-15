class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.7.8.tar.gz"
  sha256 "9aa78279c61f11e8a4405d1817e6472610922c9eec50f64d6ca924eadd3d421d"
  license "MIT"

  bottle do
    cellar :any
    sha256 "0d34e1e16795ee82e32ffd6cfd049a99b6f47023830ca652678413c9624af843" => :catalina
    sha256 "e91b55ad88e12eec50cf3f605b6ff64d8609bfda9562c65bb0b4224ad2b6c5c4" => :mojave
    sha256 "7ef296d5928ff6aa279c3f959c64553d63967a2dea3077a30def78783e21f5a0" => :high_sierra
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
