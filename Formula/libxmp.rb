class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.5.0/libxmp-4.5.0.tar.gz"
  sha256 "7847d262112d14e8442f44e5ac6ed9ddbca54c251284720b563c852b31f26e75"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7f9283a77ff4c8715bd198177863b376a745a79be193da5adb1fb5704abd941d"
    sha256 cellar: :any,                 arm64_big_sur:  "434828daa308ed44a901c51be2e6b5a92e91e28267f77894aff8a5030c07d82c"
    sha256 cellar: :any,                 monterey:       "5401c879119fef7ce2c6101f96ab9977f53ee1fcb0d7015e75b9ed7564ec3442"
    sha256 cellar: :any,                 big_sur:        "73e8a533ff1ea91a3b09adb60218a80b858ab627207f5193c053d030ccfd2ad0"
    sha256 cellar: :any,                 catalina:       "60ad2fdda77476d1e2a902020ca9559e48a31f145de0d5fff0b382d3f1c07645"
    sha256 cellar: :any,                 mojave:         "ac65679e55ab676a6f2b2a13d846c7929d7d111f9b252554753f31150bbc486e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e4bd5ba020b26fa678be9791c012baf18305d87b208808502d9e3ced7ed064"
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
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    pkgshare.install resource("demo_mods")
  end

  test do
    test_mod = "#{pkgshare}/give-me-an-om.mod"
    (testpath/"libxmp_test.c").write <<~EOS
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
    EOS

    system ENV.cc, "libxmp_test.c", "-L#{lib}", "-lxmp", "-o", "libxmp_test"
    assert_equal "give me an om", shell_output("\"#{testpath}/libxmp_test\" #{test_mod}").chomp
  end
end
