class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.7.3.tar.gz"
  sha256 "715982fa66507a2e7287765aa167ab926fbff99ff2e610527b5b042f090b94f2"

  bottle do
    cellar :any
    sha256 "cf247db5aa1b730a160fa9d09ed0cd1bd4a172e2c908ec2fd1bcee386ac611ed" => :catalina
    sha256 "a09ed45644de2d8074d417b458b723fd91ec02c363dc7afc0442778eec883325" => :mojave
    sha256 "b80601ad07446255241ba811a37336a96f8fdd2bce3a17c50a1b9cdeed2ade41" => :high_sierra
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
