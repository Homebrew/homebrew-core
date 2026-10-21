class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.7.4/libxmp-4.7.4.tar.gz"
  sha256 "a25583aa3b031c78ba0b4e83387fa596fb05742622e60f60d1540ee2af79b8d9"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "93fda5c152b511eaaee3cd362886f86ea0492e08be785ce0f7bcc095bbb075c2"
    sha256 cellar: :any, arm64_tahoe:       "f50aeb7e74e46c1c34934382db3c5847389ba5351e7ccaac6b822e8a3114bb9b"
    sha256 cellar: :any, arm64_sequoia:     "998f473fab874225a675bcbd165dea19ed8d4efb9a08093bee2e453e3a9167cb"
    sha256 cellar: :any, arm64_linux:       "76b4573938095a0b2d4151ac57dc36e8d3d5f3b53c0f860856ea2addf808661e"
    sha256 cellar: :any, x86_64_linux:      "4706dd629fda1efe6140b300b87b6b251f4d3b3692f8ed644424afd82a7bb6db"
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
