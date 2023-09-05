class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.23.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.23.tar.gz"
  sha256 "74b1081d21fff13ae4bd7c16e5d6e504a4c26f7cde1dca0d963a484174bbcacd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a7321472cc9ff32a54c549556340dd1ad9dd95415828149005fb4959d04e83b7"
    sha256 cellar: :any, arm64_monterey: "62a2c1994737a2677f318a97ac64a32690f9f958086310a49f37e3fcfd5b6731"
    sha256 cellar: :any, arm64_big_sur:  "09f52f15b2a2d126213ea5631bdd35722006540f0086bd285a4f611a4b4b8a78"
    sha256 cellar: :any, ventura:        "72bf08b82cb8fb7919e1c81d9df16425d9f8b7920e8f5abec958274207d7a2ef"
    sha256 cellar: :any, monterey:       "0d0aeea95f9e7b4ccfa1e8d7f3a83b3b4d604eac1178e4f88ad51d132ad1f7cd"
    sha256 cellar: :any, big_sur:        "d52ed8dbb258f11b14eb10494aeb8a2dab91c3626b11e37d8197d2fb183c489b"
    sha256 cellar: :any, catalina:       "47e4821fa03790827af24698bf7cb833656d48e56bfb141b3093e8cabf5b1c88"
    sha256               x86_64_linux:   "7d5728174c3de6c048a233459a1b8ac9e8c53645ca14962d9a1deb60fd58a568"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # --enable-libgdbm-compat for dbm.h / gdbm-ndbm.h compatibility:
  #   https://www.gnu.org.ua/software/gdbm/manual/html_chapter/gdbm_19.html
  # Use --without-readline because readline detection is broken in 1.13
  # https://github.com/Homebrew/homebrew-core/pull/10903
  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-libgdbm-compat
      --without-readline
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"

    # Avoid conflicting with macOS SDK's ndbm.h.  Renaming to gdbm-ndbm.h
    # matches Debian's convention for gdbm's ndbm.h (libgdbm-compat-dev).
    mv include/"ndbm.h", include/"gdbm-ndbm.h"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match "2", pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
