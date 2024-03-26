class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "4eda95e34f116c36203777f4fe770d64a3158b1450ea40364abb111cf4ba4773"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5be3533e30e5528bf70dc36928db6e44520173b55edb8ccab13d721c5a4d755"
    sha256 cellar: :any,                 arm64_ventura:  "0d6240f5d9dfe9d0f5b61a8e30c712f42c536cc994884202a72816385c09c9c2"
    sha256 cellar: :any,                 arm64_monterey: "598e9efc1d3c7a5c3fe63b6cbe5e695c82ac897695747fa7092b668c4ebb1a3f"
    sha256 cellar: :any,                 sonoma:         "ab7ff7f3e221532eeac7fd4696baf3e43010e69e06ec1886638dac9222f50701"
    sha256 cellar: :any,                 ventura:        "4e9be8ac67554ab5a512c3b976cbc79a05bce98fc2959ea831863e4f1ee30a9f"
    sha256 cellar: :any,                 monterey:       "27cac43c3f885816ee65d6969e00b471d3cb79c3084608acc1f5f0b963e7d462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ebf271b9b2221e34d7b7f248f80dcf8beb4e78f5bd721fd5c0fd18b5b4dbec2"
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
