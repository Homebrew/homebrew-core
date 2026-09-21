class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.7.3/libxmp-4.7.3.tar.gz"
  sha256 "b6a98797e4fb9c9a705f5d53112aa5214561857e929a644928b9e658930d9440"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4dcbd655092921674b98814113ce1c1b2b21c5946a9082ed54ba2decf9635e05"
    sha256 cellar: :any, arm64_tahoe:       "7da7a7e8c2b159c2b15d4f89341f0a93b11947c1cb500e57fadb3943998865b1"
    sha256 cellar: :any, arm64_sequoia:     "a9e25e3f437332c021c650fb5a9a8fd2e51122617cbe073d6cac9111edaca02c"
    sha256 cellar: :any, arm64_linux:       "f057de179a9ad9866ddd25368f1faf860ea9f3520b7bd3874b7efe5249288820"
    sha256 cellar: :any, x86_64_linux:      "803471645527a585ee35e06357e09aa8d98f86687462f3b986cebb990603e4a9"
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
