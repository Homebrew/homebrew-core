class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.7.2/libxmp-4.7.2.tar.gz"
  sha256 "510a96eefd79e4558fb1fa41fb5494870328776b3f77563f94f61f241f64bde1"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7cb3fb487400b980835dc20acb69779ef9cdcbbf89008e252d56329dda3610b0"
    sha256 cellar: :any, arm64_sequoia: "06ae96e14958654c243dffbeb09863b097e705cfe89eff732ce194573a0d0788"
    sha256 cellar: :any, arm64_sonoma:  "beaddbcd68c5260efd6dca97b6c8cc311e322fcef22e4c39714b4c80d3b68568"
    sha256 cellar: :any, sonoma:        "5900fd3ab0fd2b7d852cfc472128cab3c71b274f6d71408a9d9cd482a272634a"
    sha256 cellar: :any, arm64_linux:   "e8753a783bb56fe6fbda76d3912af25f9f79930da4f7c95b71a1319b53f04a3f"
    sha256 cellar: :any, x86_64_linux:  "3b672eda22d9aec83153bebf9aa82909462cc17f6293565ce74e6db0ecdade07"
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
