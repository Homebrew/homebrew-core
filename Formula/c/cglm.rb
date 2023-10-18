class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "ba16ee484c9d5e808ef01e55008a156831e8ff5297f10bbca307adeb827a0913"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aac129480d42126a8b38724a2549f528d911bbb32609dab1b7ecfaca97292343"
    sha256 cellar: :any,                 arm64_ventura:  "0ad91be63d1d5a20d1013ef956eddf280b28dfd4dc6e1df235d24d2cb52ca5f8"
    sha256 cellar: :any,                 arm64_monterey: "8d193551025d3f4bab0e571108cb0ac84ba6fa948ddaa210e18f7bacbd9ad371"
    sha256 cellar: :any,                 arm64_big_sur:  "428d6899f28318fb3933c77b1756a70b8df8c67b1cf0ff260df43db640e2b422"
    sha256 cellar: :any,                 sonoma:         "5c6ade26151f5ccd2d87ab092ebfba20fdd1c1a8fc30ecb30b665069d73e8e42"
    sha256 cellar: :any,                 ventura:        "5b07487bae460a44203457eb1e7e1a753b0aff917c7e68a05923fbc5c2e27a7c"
    sha256 cellar: :any,                 monterey:       "52ee39da4fb86682f113aa8017b40ea771f23383b1297c3784f3267b3248f822"
    sha256 cellar: :any,                 big_sur:        "9d53907b292a09644c130e4bb30fc7db8de473d482c34ef5326fa9f2c8dca220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9538f6e96c029fe704fd0f797f0fa6f9900eca7bce5495f9052a535fc6142ea"
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
