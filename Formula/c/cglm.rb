class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "101376d9f5db7139a54db35ccc439e40b679bc2efb756d3469d39ee38e69c41b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1ad803ddd6428b7c677461ae3eb1cbdcd291a351cac692cc8a37d2e648be6cab"
    sha256 cellar: :any,                 arm64_ventura:  "ccd1f2fc02fbe4ec93f827b51c63df903dfa6386001cfd35c5445f39a97213c4"
    sha256 cellar: :any,                 arm64_monterey: "f52fea8d00aa4b0d0b257af26d0055da43c8e28688f89423338f2904ff1ed0b8"
    sha256 cellar: :any,                 sonoma:         "3da6c026eae1b0a9aa4eee3e04f73e58c8303093fb2f50acc1c4fe962f367f09"
    sha256 cellar: :any,                 ventura:        "49ace90629f9606a33e932e26a44c4ac48403ebfb004d1681c345bdf7b6b38e1"
    sha256 cellar: :any,                 monterey:       "5fd8a51b5f1e138a50e123ae5514896dd9f6c96dd879eb7076889a490fa40ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3474c4cbe7b24d7be7cf198f2c8dd5d9779c381d1e5230fef79de7348656f79"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
