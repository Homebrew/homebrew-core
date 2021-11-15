class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.1/libpsl-0.21.1.tar.gz"
  sha256 "ac6ce1e1fbd4d0254c4ddb9d37f1fa99dec83619c1253328155206b896210d4c"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "899906030e256c5132cc6a1a709c283161701f950f698bee27d6f7e54d7d71df"
    sha256 cellar: :any,                 arm64_big_sur:  "f2330a5e4084401e4c60bec2da48cc2d877e777c51f8106f9c11653612dc7337"
    sha256 cellar: :any,                 monterey:       "70c916c1ccdda936de0cc1de6a17c066f6ecf2d76204482137f122852787e0bb"
    sha256 cellar: :any,                 big_sur:        "dfb143c0316dd1319165c09d9cfd8cb3ed47a572e538b88755bae8f90de594b9"
    sha256 cellar: :any,                 catalina:       "6ebd02eb47c7a10b1b60360c6f2467677feba8d81a3a4e9e4cb09c08180395f5"
    sha256 cellar: :any,                 mojave:         "7ce4c33579aa8d7263df78f1814166a8a14a26b28866bbd8772c9a0bea9726a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e95d796f1b490d7720f3aa1a9dd6d3799ccf99be87194dd2b4bcd72d00c626a8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "icu4c"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Druntime=libicu", "-Dbuiltin=libicu", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libpsl.h>
      #include <assert.h>

      int main(void)
      {
          const char *domain = ".eu";
          const char *cookie_domain = ".eu";
          const psl_ctx_t *psl = psl_builtin();

          assert(psl_is_public_suffix(psl, domain));

          psl_free(psl);

          return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lpsl"
    system "./test"
  end
end
