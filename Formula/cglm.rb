class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.7.9.tar.gz"
  sha256 "c96dd8a6f1d9aedb7ac02fe6bafd2a3a625a19e62bc18d455faf9c6825e9bd7b"
  license "MIT"

  bottle do
    cellar :any
    sha256 "200eed2ddec2f9b1bd83389a028a87f33f1e21f189113e73d1b07827b68f1d5c" => :big_sur
    sha256 "68743db1f6da6f8f865e664c574691bdcca09dc741315f303b2985bb8e4d5538" => :arm64_big_sur
    sha256 "9da6d7be20925e8e0cbb7d1fc0faa43a15fb00063d9f7b8123ce19a8eabfb1a9" => :catalina
    sha256 "096de5d9570f52485674b349e763f53f1939240d3e6596444b6ac7a0daf6aa39" => :mojave
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
