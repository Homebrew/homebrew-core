class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.6.2/libxmp-4.6.2.tar.gz"
  sha256 "acac1705be2c4fb4d2d70dc05759853ba6aab747a83de576b082784d46f5a4b9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cad29336b72066c119b14cdc151ed153791f48891205ad0c8165083e0a767e82"
    sha256 cellar: :any,                 arm64_sonoma:  "db3b303b12e4c78572f024758e708eb450a6f88f56c8f6235d4ca1f71f99a759"
    sha256 cellar: :any,                 arm64_ventura: "33d0997205204bb8d3c5f8a94f7e0a53cbd81eb0b8cc0525a10f047642763054"
    sha256 cellar: :any,                 sonoma:        "ae85827745c2959cc955737668515f20db08780bf0dc4599f4d8a5dea77c1058"
    sha256 cellar: :any,                 ventura:       "f78dc6db1f4a004cb580e35d8cd32cf104a4de1796d90267f198dd50390828f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5947b7466e9f089143a4a1d8a4d223bd284234c06f8d160d0a157e55e99ee160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bd56a6ee5dace91cadfbb3e015f92a98c334f39820eaf0240f47695702bcd8a"
  end

  head do
    url "https://git.code.sf.net/p/xmp/libxmp.git", branch: "master"
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
