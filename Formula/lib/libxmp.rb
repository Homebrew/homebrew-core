class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.6.3/libxmp-4.6.3.tar.gz"
  sha256 "b189a2ff3f3eef0008512e0fb27c2cdc27480bc1066b82590a84d02548fab96d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f6f2e2a3e5ff0282530bd409b107b808cb289fb35606e96d5c6250d939a347a7"
    sha256 cellar: :any,                 arm64_sequoia: "746c3d92562469f5200fe2bb32f18f43c7bac6416e4e6cfa4ceb825d10ee13c8"
    sha256 cellar: :any,                 arm64_sonoma:  "7bad2e453d99d72bf38ab45f8c843c3ca96f9e845a24493d889000afe5a1cbd9"
    sha256 cellar: :any,                 arm64_ventura: "d69cfd7a46845980beb6169e957088d81259cbfc22149f86d0d81e47b8ea261c"
    sha256 cellar: :any,                 sonoma:        "c632e6c890ccb5aa8fd15b67323a25b197465771515088844cb6d3a9f739eae6"
    sha256 cellar: :any,                 ventura:       "dc9a1c17688c400188dbb91726bb2b8d4749ff477d494df1b1c8d6c4d8f010b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6533f946457471d6fc7fe7fe7481085be039c7ac7bf4f0813939b21d9f74e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a650c8549008d6e0b13fc813e9988372a943b0a2a8859b303d755da69e5deea"
  end

  head do
    url "https://github.com/libxmp/libxmp.git", branch: "master"
    depends_on "autoconf" => :build
  end

  # CC BY-NC-ND licensed set of five mods by Keith Baylis/Vim! for testing purposes
  # Mods from Mod Soul Brother: https://web.archive.org/web/20120215215707/www.mono211.com/modsoulbrother/vim.html
  resource "demo_mods" do
    url "https://files.scene.org/get:us-http/mirrors/modsoulbrother/vim/vim-best-of.zip"
    sha256 "df8fca29ba116b10485ad4908cea518e0f688850b2117b75355ed1f1db31f580"
  end

  def install
    system "autoconf" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"

    pkgshare.install resource("demo_mods")
  end

  test do
    test_mod = "#{pkgshare}/give-me-an-om.mod"

    (testpath/"libxmp_test.c").write <<~C
      #include <stdio.h>
      #include "xmp.h"

      int main(int argc, char** argv)
      {
          char* mod = argv[1];
          xmp_context context;
          struct xmp_module_info mi;

          context = xmp_create_context();
          if (xmp_load_module(context, mod) != 0) {
              puts("libxmp failed to open module!");
              return 1;
          }

          xmp_get_module_info(context, &mi);
          puts(mi.mod->name);
          return 0;
      }
    C

    system ENV.cc, "libxmp_test.c", "-L#{lib}", "-lxmp", "-o", "libxmp_test"
    assert_equal "give me an om", shell_output("#{testpath}/libxmp_test #{test_mod}").chomp
  end
end
