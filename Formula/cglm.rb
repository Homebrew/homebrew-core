class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "c7022e3e8973cdd96393c251e08e4f136f327d11f64b4c63cf6ea69bf0c0963f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e02b0e3d1512aa085c5e35c7f44a7ae1b16d082aa17390d63207c4ac403942c8"
    sha256 cellar: :any,                 arm64_monterey: "dc27012d84ca55d6cd6628df97f7d8dea55476b9bb2d5a6682e07ed327a92844"
    sha256 cellar: :any,                 arm64_big_sur:  "beb288cac02cdb3c5ce36d468ee8b2f6959cd0cd9a33166dd24a5329f3c98107"
    sha256 cellar: :any,                 ventura:        "2007351939ecbe5c84317394c81272738e7cf4d043beb24d51a206df384e04dc"
    sha256 cellar: :any,                 monterey:       "2ac3f5abb771c4167b1f9945a71a61e4d6475b6a57c801ca32f2066f5fb0de26"
    sha256 cellar: :any,                 big_sur:        "1e08d60ac1d7ce2da3b67a550022e312fdd8f7323283f136d15d52415516179a"
    sha256 cellar: :any,                 catalina:       "a93d558aacae2e4695e0ca6c3ae9000e81a4c4b372fa5444ea1dcb7d6e3ab879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecebcec3761661a758a3feb19b84d026f04cfa44ca66bb22e7482f43f14033dd"
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
