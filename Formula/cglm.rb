class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.7.4.tar.gz"
  sha256 "550a2fe09c9627189f04ddd83c324bafad3367ddbac9ff6684c2808d067927c0"

  bottle do
    cellar :any
    sha256 "6a5d8dfd8e51b2bd8f3fc1040a5343bd72feb3f33dd27007c2bfc9ec6cf5e23c" => :catalina
    sha256 "3062af7484b8fe4e5e44068c0157824542584c66f2c79628553a8010fd261592" => :mojave
    sha256 "33d1294407b153435704cd5d942d155fdc36c799306c483a0b8a738a5798343f" => :high_sierra
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
