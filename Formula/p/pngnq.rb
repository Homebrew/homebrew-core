class Pngnq < Formula
  desc "Tool for optimizing PNG images"
  homepage "https://pngnq.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pngnq/pngnq/1.1/pngnq-1.1.tar.gz"
  sha256 "c147fe0a94b32d323ef60be9fdcc9b683d1a82cd7513786229ef294310b5b6e2"
  license "BSD-3-Clause"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "d463943082fa76cf5dac7bfc957001bb2445351a77b79dd4f317dc6266b114e5"
    sha256 cellar: :any,                 arm64_sequoia:  "06007a7ead893b75a74fa9f5cc7c466219fe2be5149a245e0ae560dd52503aae"
    sha256 cellar: :any,                 arm64_sonoma:   "951d02bef2eeb1252344215eb818f95c269506f4f678b3755df4a0c483277f8e"
    sha256 cellar: :any,                 arm64_ventura:  "871a8ea613320d94c57aae21e6fb9e3d42016d8ab88a6fd30b1f4e915591badf"
    sha256 cellar: :any,                 arm64_monterey: "31c85fafb9fd2051db06856042a3f216f9fd24fbfd8acf95f5a51bf695989a02"
    sha256 cellar: :any,                 arm64_big_sur:  "21e94d2f987e060920488bdaf121792282548dcf196eed01e4fd5221db414685"
    sha256 cellar: :any,                 sonoma:         "5b5739e2d4628da75276dc69041c088fd960f1aae9d6f827c8fb92bddabd2e59"
    sha256 cellar: :any,                 ventura:        "0cc5748776f48d4460f726fd20d0015761c3640e8ab644a024dd967edf9d67bd"
    sha256 cellar: :any,                 monterey:       "d84ba4d373165ff3999b3c20e49ebdc69f8374a7c04a6fa48fc68d337a2e5924"
    sha256 cellar: :any,                 big_sur:        "42695d06f657acabd7c229206d3623ca3830667c4ab1308d5371cbca7beb48bd"
    sha256 cellar: :any,                 catalina:       "f438c5d73e9dd9c3c36283aa9f8253168de30f52242955a803714350cc247c80"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1af6b55b0fed98058a42791addbbd0793767c0e7a8de383abdb0476b57bdc1f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ba477730fc049d9a7b16d94247a14e3ad6fbace2f40f8aa5d180822d12e173"
  end

  depends_on "pkgconf" => :build
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    # Starting from libpng 1.5, the zlib.h header file
    # is no longer included internally by libpng.
    # See: https://sourceforge.net/p/pngnq/bugs/13/
    # See: https://sourceforge.net/p/pngnq/bugs/14/
    #
    # strncmp(3) is declared in <string.h>.
    # See: https://sourceforge.net/p/pngnq/patches/6/
    inreplace "src/rwpng.c",
              "#include <stdlib.h>\n",
              "#include <stdlib.h>\n#include <string.h>\n#include <zlib.h>\n"

    # The Makefile passes libpng link flags too early in the
    # command invocation, resulting in undefined references to
    # libpng symbols due to incorrect link order.
    # See: https://sourceforge.net/p/pngnq/bugs/17/
    inreplace "src/Makefile.in",
              "AM_LDFLAGS = `libpng-config --ldflags` -lz\n",
              "LDADD = `libpng-config --ldflags` -lz\n"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    system bin/"pngnq", "-v", "test.png"
    assert_path_exists testpath/"test-nq8.png"
  end
end
