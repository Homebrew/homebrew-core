class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.8.4.tar.gz"
  sha256 "42f84c42c8a3e62954da77ab5c5d3264033d5802009e175db7921332a476126e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "30c211f655e4347ed7e5582ff08643f53406b8427d804d8634b13add6dfdeb2c"
    sha256 cellar: :any,                 arm64_big_sur:  "29ff2689e54b405a92d819ff5cf12a07f3d89bceb5094d623f3ccdccfd818862"
    sha256 cellar: :any,                 monterey:       "99c7d4574ab2000dfc461fa623382d9432db7f9b2d92a56583ac6b63e9c62577"
    sha256 cellar: :any,                 big_sur:        "2fe11e20a528578738d09dc81ee3454655aa847d35bb3c2476e4b398071399d0"
    sha256 cellar: :any,                 catalina:       "cafb0e2119b9d0a56acd3cb8c2aae7438a4dd9aeb3bf4ce1014780c3ef2dcccd"
    sha256 cellar: :any,                 mojave:         "3d9041245205d45fea1da390d139fa2457a92a5181938b6a51c1c8de3393ce74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c5030d9019fae7bea72f57d9fd7ff9efbd3bc5e70bace3f34aa1e10a3d53a5"
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
