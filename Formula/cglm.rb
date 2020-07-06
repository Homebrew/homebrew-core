class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.7.6.tar.gz"
  sha256 "29ff8af4edc03697e36d3e6f99a80b884a80ee09d46055ce45765e5d6b2456d9"
  license "MIT"

  bottle do
    cellar :any
    sha256 "71acb4380ab467ed76133c76d7b971a9914c0ba07b41ad51ee7e5b74334b6861" => :catalina
    sha256 "253894ff185a4f8499253543a8cd246dc8958f65746f3319f1e311c0f81feabc" => :mojave
    sha256 "683def15df6b8bf55a4954a3427291b559204975b5cdc35d74a18170d4e7db58" => :high_sierra
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
