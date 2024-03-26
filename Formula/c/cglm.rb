class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "4eda95e34f116c36203777f4fe770d64a3158b1450ea40364abb111cf4ba4773"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d092a574c89c363a3a88736d7a46791b26974bbd1ff1ceb1e9772028e4ae215a"
    sha256 cellar: :any,                 arm64_ventura:  "b6f40e74979ac3d88e364f5f4ba649089fa01bcf868f69bfdc04f0dab7ac2053"
    sha256 cellar: :any,                 arm64_monterey: "70fe0d9feffa29de2eadfcc2af24894b3bdbb46fecbdd131bd38d3614eeb718d"
    sha256 cellar: :any,                 sonoma:         "c3d32ab83959f8be1a0bc55706379bcc59d5cba38c7903734881d46aa8d59e74"
    sha256 cellar: :any,                 ventura:        "2341e38d982a32c4dd1a538d3ab2a913daa899910f6279ca0aa9b886142a56b2"
    sha256 cellar: :any,                 monterey:       "24cde6fb4a96ee2bd17860f0cd1846c392114ad2779ffa0fe16b962a1297a577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d845c6c354be613a49df541acf3feff9a2e2053591fb73d2c94bd399750b57eb"
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
