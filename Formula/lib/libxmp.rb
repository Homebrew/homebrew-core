class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.7.1/libxmp-4.7.1.tar.gz"
  sha256 "398052ddff91472e9939240422d10b92149a1f5b80d2455ff5dde129f10c28e5"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f2bb8ea11b88256c4f5be9424ebc882da174646bf1b4416d981b7d4be1a683d4"
    sha256 cellar: :any, arm64_sequoia: "278eed736852ea947174f5c28a4692b81e1655a12b14456c5a26ba3b4a1ad9f6"
    sha256 cellar: :any, arm64_sonoma:  "bb3cdb21b877bff195f7c9065196f696e0a626369e19d216406aa09e4110abc7"
    sha256 cellar: :any, sonoma:        "9668a8b6261f158709cbc8dc7659a2d233ef329bece3cda7d15b84eb5a636632"
    sha256 cellar: :any, arm64_linux:   "33bb678771344516f62f4a61e51fd1d968862468588a4b317bd9f4049a99b6e5"
    sha256 cellar: :any, x86_64_linux:  "723e786b81e72a799764f23f01caedbacd74ed4e386d4fbf0012a454782562bf"
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
