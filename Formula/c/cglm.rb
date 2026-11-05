class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "cc0862eee2885d2a2b4870eb29b97c6e9b9ebc7c66e8854e1fa8f3d18d9d8475"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9be593ffe528f33536114691a8a6c414b3e33f59cbe42cda9e6f5bdec30f6764"
    sha256 cellar: :any, arm64_tahoe:       "87f7219dfd53d2c6727eea73adf042b0d7b738477b0abe6179ae82b56797153d"
    sha256 cellar: :any, arm64_sequoia:     "74a856f6275e385834b4120442714bbb1884ab94261128004d24205b96f0a2a7"
    sha256 cellar: :any, arm64_linux:       "1643f8ca8ea56a8f4a713b3176cc0381bc4714b2dd77b75161b51a2141c32878"
    sha256 cellar: :any, x86_64_linux:      "58910e2caf5056addc3bc9b3351b3702f13152fda26c10280d710d00137e7f0e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "-I#{include}", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
