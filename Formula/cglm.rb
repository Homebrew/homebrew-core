class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "9561c998eb2a86dca5f8596b5cd290d76f56b7735c8a2486c585c43c196ceedd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5c681487720bb2425913f923ea18457e8a7b05f764b7026e15d679fd6d1caa1b"
    sha256 cellar: :any,                 arm64_monterey: "d2fade77b3795e4a92a6545984d81a36458643e756b5b26a3a48b9d26f0b0a1d"
    sha256 cellar: :any,                 arm64_big_sur:  "d69fe43c2a662ed77a3bb71b27d3601fa6df53ed0b9d7f30f7dff9f03a141a1e"
    sha256 cellar: :any,                 ventura:        "7afec36968ee4cf2b4acc9c80a38709c027a3985831854f6690b90dd7009440f"
    sha256 cellar: :any,                 monterey:       "11a427d7a27ae6cd6b2dad65ff6adf7ab5c0b57aa5af098ffa27ac953b7d0ef4"
    sha256 cellar: :any,                 big_sur:        "70ecc406b6e5c5830c8f1dd97ca59434d4c4e4d8c30e00a2a9b2ac676380de5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a0b73b961bc8d93e17f4d9ca369d10fa8ab8190c0773842c3545c5f68e42e6"
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
