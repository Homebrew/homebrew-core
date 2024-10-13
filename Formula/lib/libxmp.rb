class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.6.0/libxmp-4.6.0.tar.gz"
  sha256 "2d3c45fe523b50907e89e60f9a3b7f4cc9aab83ec9dbba7743eaffbcdcb35ea6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ba1d5d911bfaed579ca8145659fba1c8c42ba0c398cfd2cd606188ade06a00c7"
    sha256 cellar: :any,                 arm64_sonoma:   "94c26999911fa5ebc6f479d16379a978991b4e9d27a32ae32ffe1009204e5bbd"
    sha256 cellar: :any,                 arm64_ventura:  "029903dce869ca4f3f82fb7b01a8b0212e295cd196492054e91406f33854a2e6"
    sha256 cellar: :any,                 arm64_monterey: "9c57ab8f4034df4437ab073dcee4620619ec871bafef40056211040cf4a5b39e"
    sha256 cellar: :any,                 arm64_big_sur:  "dae1b586020c2313cb250cbae91dcf6d1c7460ba41140651a6adbcf36c4d5b5b"
    sha256 cellar: :any,                 sonoma:         "93ba8ff0aad9a3eb3593c800a5b5f035c6ae88345226a455f7eb0bf8e509d1aa"
    sha256 cellar: :any,                 ventura:        "a91c6641aeb8c38f4ad918552e2d800b11a71c079547e5fa4aaa191b2c90cb1b"
    sha256 cellar: :any,                 monterey:       "86f47ba5a880837e146fcceff8f84e871f036819c113b37bfee14030c4f14705"
    sha256 cellar: :any,                 big_sur:        "2f5fbbafd7ab69435770417e3f4a8733278a9c1c5ffef54917ac0959e12b244a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeaed38946aed912b19cbd140270eeea27f60e5735b7840b64a6e51d836463b6"
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
