class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.5.3.tar.gz"
  sha256 "e5e44538688be70b79556cc69c6aff4ac7757f160bbff7068ed3e88d64541522"

  bottle do
    cellar :any
    sha256 "ad33c39fcb87adccb6b6c0f9161be5c0816ddd0c85db7400a9ab0a46e8d8ae62" => :mojave
    sha256 "4b92368989d22d043a0ffa67eeda567d4398c48eab8e7ef7a964821e8ea3d395" => :high_sierra
    sha256 "76704542b282c1510b6520b48ad6abe7302e0867f25b8e1c8ed202f8edc83f53" => :sierra
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
