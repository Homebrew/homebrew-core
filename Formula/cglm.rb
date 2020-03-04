class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.7.1.tar.gz"
  sha256 "ed8ac01fef1ed4938701e86d8a0744e994975dca01dc20d3fbe419215e459136"

  bottle do
    cellar :any
    sha256 "d03dbd49ca7c4eaf65c79d8baf9ba9bdba80b09282022ad7677cc4d80cc07cb3" => :catalina
    sha256 "eae499b98f846f8e48609ee12055b69297eef0d84baecb1baca0683211652d5a" => :mojave
    sha256 "6184f901f7835a1fa00228d7e48951b12f8ae3c6be7c910c0786690134999778" => :high_sierra
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
