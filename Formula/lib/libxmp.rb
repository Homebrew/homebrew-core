class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.6.1/libxmp-4.6.1.tar.gz"
  sha256 "af605e72c83b24abaf03269347e24ebc3fc06cd7b495652a2c619c1f514bc5cb"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7221a84d10e70543b1a038487f3ba79e51a820441e7e9bd91bec492d94a567a8"
    sha256 cellar: :any,                 arm64_sonoma:  "75cd02122e6e123f76b3edf2b2e463a7b332da21ce5c4b2c18248d10fda3c7b9"
    sha256 cellar: :any,                 arm64_ventura: "16f5e6cf7416fbf9e41a143279bb08ee8dfc4d00b8dfe3d8a7d7307b8eb089f2"
    sha256 cellar: :any,                 sonoma:        "7f3cf128ae887cf581b87085847568fc5ed15c87fe79a1c4df670fe8364338e0"
    sha256 cellar: :any,                 ventura:       "839d29df4edf70ea6cc0626b74b40bfdc5128de75c56aeebf8fc0d6d73650d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7802dd184e45c01811f34636e77424930583a34b0dfe0f524ff9c74a701c7f87"
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
