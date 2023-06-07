class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "9b688bc52915cdd4ad8b7d4080ef59cc92674d526856d8f16bb3a114db1dd794"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7d6139b47104324fe73b522e1c7fd63c51008d220b06d33de9088ee495c58e1f"
    sha256 cellar: :any,                 arm64_monterey: "9af4d083be71a5a7e73b7758a7b94015bfbd9ed2b649cd450ac89e4e37e0a732"
    sha256 cellar: :any,                 arm64_big_sur:  "66be16180b40d9330134a6c1d4f72ab344393801069cd1529961744a32ff4699"
    sha256 cellar: :any,                 ventura:        "09ffd46bc5f77d667d1ff90fa6d4d1292d70f8720da52e3c78c1b15b75c833de"
    sha256 cellar: :any,                 monterey:       "349a13ded9f19d63c68587af674cd603e7ce97bc11d25b545fcf6e95e1f7301c"
    sha256 cellar: :any,                 big_sur:        "9960789a764ac56b204fdf03fb76d2a0a5eb8980ab840ff6b824fe5baa6eb52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "749794c4dd2e8de4a3b8f114aed792161b014740434e885b0b84059253a8c7dd"
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
