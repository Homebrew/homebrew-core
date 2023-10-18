class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.2/libpsl-0.21.2.tar.gz"
  sha256 "e35991b6e17001afa2c0ca3b10c357650602b92596209b7492802f3768a6285f"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "669b3ec271b052f66ea65aad5deee3757010f90d74d4b76231333b5d4f6720de"
    sha256 cellar: :any,                 arm64_ventura:  "54e6c05ff0b41c160db7087ee741d616c899c63a74e157e4a74007be055bc4b4"
    sha256 cellar: :any,                 arm64_monterey: "29b19583775b9a640685e24bd453f16a3e5be86546b828561a6ecd338a662e80"
    sha256 cellar: :any,                 arm64_big_sur:  "f6f58b4348f12016325eb53fa4e1cfd35dc558a42147c16498560c7337ef24e0"
    sha256 cellar: :any,                 sonoma:         "c1939620d3b71cc9a6b03836e0d6c304bf4b37ab9789f5b9067319a70a79f6e9"
    sha256 cellar: :any,                 ventura:        "cc6122f645807aaa12528f23f94a006e2cc0f826a0640ec05c1fd5549fa48f49"
    sha256 cellar: :any,                 monterey:       "d37094a8cd209afbab03e05ce8cd0e0300639a1ac368317a2cd1f50a09edffd5"
    sha256 cellar: :any,                 big_sur:        "ba7c45172edcb181c9865cb0f607945f8f01905aa8b01e36d83930141873f461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eea17163910178315e7448318bb74b70fc69eec179c44dbdbb64183b32f777d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"

  def install
    system "meson", "setup", "build", "-Druntime=libicu", "-Dbuiltin=true", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>
      #include <string.h>

      #include <libpsl.h>

      int main(void)
      {
          const psl_ctx_t *psl = psl_builtin();

          const char *domain = ".eu";
          assert(psl_is_public_suffix(psl, domain));

          const char *host = "www.example.com";
          const char *expected_domain = "example.com";
          const char *actual_domain = psl_registrable_domain(psl, host);
          assert(strcmp(actual_domain, expected_domain) == 0);

          return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lpsl"
    system "./test"
  end
end
