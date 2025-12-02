class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "be5e7d384561eb0fca59724a92b7fb44bf03e588a7eae5123a7d796002928184"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff546743d100ac764a31e90c9022f32f4c8ca42cd067a8ba62103bd96ef94bde"
    sha256 cellar: :any,                 arm64_sequoia: "2a4e8d2c345846e569a51d36bf21c611c83c91ac112c6fd75a084c662eeeef52"
    sha256 cellar: :any,                 arm64_sonoma:  "9225092fc1d388b4a5f960a647b8a80e37364698fa073ead2911a6409f06af3d"
    sha256 cellar: :any,                 arm64_ventura: "82d198d51c5aadf126647acd3854e2182291c1b693faba90cdbafd2d66e26d55"
    sha256 cellar: :any,                 sonoma:        "7d9694362e4b318417b226674b69b217246e14325d404190197c3f993473cdb2"
    sha256 cellar: :any,                 ventura:       "2decb2f877d789d9982abca215c65c2a641f13dcd0f4b30439b1d2bdbed27318"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a339de32e874c67b2b66f5e2a8b300ba03edfe549ff0afbb01566ac90893a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6d1b5f157811a284f493a0b8847b5e011c96557579ae56aafaabf2ef6fb77b"
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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "-I#{include}", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
