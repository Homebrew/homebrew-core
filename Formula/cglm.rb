class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.8.3.tar.gz"
  sha256 "3a3f935f9f2ed5a8cb6337e421bf6f3a699a72d8cfe26fde1bbb8fde5c1c8aaf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "266ca2e10a751a7cdcca8e89d67e7deedb77c198936457903822146621db5594"
    sha256 cellar: :any, big_sur:       "366548bc1d52a7e6913fe6a458eb0139c0a5c6283034ca6378284f1f73849cc7"
    sha256 cellar: :any, catalina:      "f9f72abd059285644f882e4d9398c122283b3f205634d7e0a541b62364275f51"
    sha256 cellar: :any, mojave:        "fb508fb4278f03762270592e249958710cc04fc26dd9a5815f660cea57b65b6b"
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
