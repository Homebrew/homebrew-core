class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.8.5.tar.gz"
  sha256 "baefa21342d228a83c90708459a745d5aa9b0ebb381555eea42db1f37fdf7a5a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c48a7cc3c284fd5a61fa1aef055d1aa4c51e38a87e245e402590e8dc48903e6d"
    sha256 cellar: :any,                 arm64_big_sur:  "27d31698e3070d1f62e4be045cdb2da514d219cc0a28cb570404915aeeefcf3a"
    sha256 cellar: :any,                 monterey:       "e67358d4569ba43fade443088f73b68ff28716da31794fd7547aff0d393563b4"
    sha256 cellar: :any,                 big_sur:        "de5419cd5cd47d064f629d6aab9f9277e8e5bbd6a78bd3426dce5370f1a5e0a2"
    sha256 cellar: :any,                 catalina:       "61de7afb22328af33cf17b7df29562ea8e9865337f81c315c28efff72aaa674c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3689de044b897eb9047854f008eb8b7b7e5ce7c915cbe9f6ec6c9241d98c6f49"
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
