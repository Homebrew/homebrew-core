class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.5.0/libxmp-4.5.0.tar.gz"
  sha256 "7847d262112d14e8442f44e5ac6ed9ddbca54c251284720b563c852b31f26e75"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "edb417d203308a607caade02f7156391b9f44735d1ef2f4a310143effcb59ea3"
    sha256 cellar: :any, big_sur:       "71a0df8a26851412202809597d08ec2eb9f7d8e5c5bbea62d21dea8f0205fe5a"
    sha256 cellar: :any, catalina:      "4c1af5c4637210c681480ae62e67de516f0a9a3fa4deb2781013d40decc7cc38"
    sha256 cellar: :any, mojave:        "d86f0bd86f2cada740f5a87d9f18216b30e2383d9d572200c5a684fd73b8a9a4"
    sha256 cellar: :any, high_sierra:   "642c904938aa1797b3512f3f820283d4104a8153d2b0144003110accdc48a877"
    sha256 cellar: :any, sierra:        "019ff8e51453bf527ba6ec46fd289acc5396208e230445afb0332a18752d72e2"
    sha256 cellar: :any, el_capitan:    "8da81ed699c312c831be38295df20218663fef23aec1cab91afa7e425baaa4ab"
    sha256 cellar: :any, yosemite:      "dd80b8a6786f265488503234bb7aecffa15ab0a5c099677fd0989fd3329709d2"
  end

  head do
    url "https://git.code.sf.net/p/xmp/libxmp.git"
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
