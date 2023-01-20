class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.2/libpsl-0.21.2.tar.gz"
  sha256 "e35991b6e17001afa2c0ca3b10c357650602b92596209b7492802f3768a6285f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "747de9ae89fc15f597e7ba88ab38d5724e83db2ed97092e83842f5cb43d99afa"
    sha256 cellar: :any,                 arm64_monterey: "bc5fc1904d283c30a582a2436c665f60a110b71985b539829ba58bffe5b2ad7a"
    sha256 cellar: :any,                 arm64_big_sur:  "58c9e7b7c68a294319bb0ad6ffa4324ff04c255607fb54754a81a7146af8fd77"
    sha256 cellar: :any,                 ventura:        "7627adb6d9998407e7a29f6945e379a4659db45fd52129ade36244de40f74bf7"
    sha256 cellar: :any,                 monterey:       "dcfaca272bdd3dde8b5a00f0b5ea3a791216abea45dce36e4689d5c587ff4dd5"
    sha256 cellar: :any,                 big_sur:        "b128e094dde2f7a821c1ce88e0efebe6c50de52f5ddd240745c8317c61ce28f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b2956d04539e66fcae71eedcabc4501ebc78b5411be75368c46326a3386d2bd"
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
