class Pngnq < Formula
  desc "Tool for optimizing PNG images"
  homepage "https://pngnq.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pngnq/pngnq/1.1/pngnq-1.1.tar.gz"
  sha256 "c147fe0a94b32d323ef60be9fdcc9b683d1a82cd7513786229ef294310b5b6e2"
  license "BSD-3-Clause"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "2620068d9fc38a44ae6f531bf96c375f66ada13346305f21ca928ef23746c2c7"
    sha256 cellar: :any,                 arm64_sequoia: "22e6dab5a0b73dc8ccb43b7e5c6fac16e697dacaf1e719ce53b3a7b74b9db9a7"
    sha256 cellar: :any,                 arm64_sonoma:  "90211658315c738ea4db4aee3a10b2600e513ee62da4e8b94c4465dfa71d1a33"
    sha256 cellar: :any,                 sonoma:        "a705de8c00c50759ad33d85f92bf005882b37b681d97451290ec6b4677993c55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c249a8d67736f14b8d2e3353e9ab37df8c64a57f5f741e93964a5f4fb50e073f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c299814b5e7a395acdc6ee57591bbcbff32a0ff32a46041cbb6706832151bc78"
  end

  depends_on "pkgconf" => :build
  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
