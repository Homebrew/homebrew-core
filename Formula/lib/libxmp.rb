class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.7.0/libxmp-4.7.0.tar.gz"
  sha256 "b6251de1859352c6988752563d60983cb8aa9fd7dfe9f81b8bc6688da47f3464"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88d5d2388523d805708402d5fcadb0f3063e7bf11f2d5fe8ddd035710efb50ee"
    sha256 cellar: :any,                 arm64_sequoia: "f2e1fef29eb4abc782ab10aa63c6c72e1fefaaa22d9aafa2f466065ae83b3cc5"
    sha256 cellar: :any,                 arm64_sonoma:  "8b6fc49f02c1f0d33ddf757dc1c6ac79ccb6abb286440458514bf4c7f4958de7"
    sha256 cellar: :any,                 sonoma:        "08ee2e1f97a46b501c5a8b7d379c91374f52c1e24f988ea02198cb43d5b952d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cd5f291ec22438e9858e6004785557d40091ca60ca69383c39478b687f995fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dcdfe5efc08578f47881a4143f474122ba91a603c001ef0fb3ddedc9dbdcb68"
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
