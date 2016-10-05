class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.4.0/libxmp-4.4.0.tar.gz"
  sha256 "1488dd953fd30384fb946745111824ad14a5c2ed82d76af671ac9cd733ac5c82"

  bottle do
    cellar :any
    sha256 "938982cdeda816e3ca2c733c2406486faf986a662678a499b60c5d9d911ce975" => :sierra
    sha256 "191951654a31f81bfb55c8d71d8cd195fc379e433e824f6b9ce629a0dcb152a5" => :el_capitan
    sha256 "352f3989d9c9250f710c112d884cd1e37b2096296f279b1f0f0f025978026638" => :yosemite
    sha256 "128521103f100741a14d8301a359f27bebb2568610f402badfa1f41632824b35" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/xmp/libxmp"
    depends_on "autoconf" => :build
  end

  # CC BY-NC-ND licensed set of five mods by Keith Baylis/Vim! for testing purposes
  # Mods from Mod Soul Brother: https://web.archive.org/web/20120215215707/http://www.mono211.com/modsoulbrother/vim.html
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
    (testpath/"libxmp_test.c").write <<-EOS.undent
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

    system ENV.cc, "libxmp_test.c", "-lxmp", "-o", "libxmp_test"
    assert_equal "give me an om", shell_output("\"#{testpath}/libxmp_test\" #{test_mod}").chomp
  end
end
