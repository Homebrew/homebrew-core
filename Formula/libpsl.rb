class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.1/libpsl-0.21.1.tar.gz"
  sha256 "ac6ce1e1fbd4d0254c4ddb9d37f1fa99dec83619c1253328155206b896210d4c"
  license "MIT"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "33e8c735f9e1bcbf1965f4fdb61ccf73afaacba62623f9bd708edd2e20c31974"
    sha256 cellar: :any,                 arm64_monterey: "e557dadaa6ae91265e67c280cd809c0cbf5e6b02215a6345115f6e0f8d52d315"
    sha256 cellar: :any,                 arm64_big_sur:  "99118a8a981f19bbc3ce71e1fabbebf92cda62f94d4294c5d58ada5f50f6e859"
    sha256 cellar: :any,                 ventura:        "93fe13888b190954713cdb04a84a45521820e22772d1f21c7e230844b66e90e1"
    sha256 cellar: :any,                 monterey:       "2a9b432b666f483235e80cafa9201920df70b1c8e4ad53f819f8d4607818d0e2"
    sha256 cellar: :any,                 big_sur:        "9a7d0cf58a69d6b388775d32c093365e6ae8d56cf0b362af6be6b4c067202a5b"
    sha256 cellar: :any,                 catalina:       "a6a89728976c0687f579b4c13fa0537b82d38e1aa01dfe965518e00192e4052b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b67f7d46ea88425ee5b1a0ebba7b6c28ed7d035c1752862613eb40682bea319c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
