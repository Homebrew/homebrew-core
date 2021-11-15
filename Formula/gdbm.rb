class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.22.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.22.tar.gz"
  sha256 "f366c823a6724af313b6bbe975b2809f9a157e5f6a43612a72949138d161d762"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "25cfaedb0fd8f973835f30754e0838747b01da48071d6cbb9c94add907287fea"
    sha256 cellar: :any, arm64_big_sur:  "ee9c72472b2e910435fcd2410c299cf784471132decba1e6945a68e29b0c5ddf"
    sha256 cellar: :any, monterey:       "b5f3343eef068c75c152fa0c2a4e8fdec033dc90f072f686bcff0298c6c4857b"
    sha256 cellar: :any, big_sur:        "7e9737ec99942ede2bb0c522f0e0c4f7c22a31aa94afa9fbab9c8bc81d2ea9d0"
    sha256 cellar: :any, catalina:       "f7e29005a4a9232965f67ef89364193e3ab95b249b169164be10db9e56f7f22e"
    sha256               x86_64_linux:   "5942379d8543bf2780fc6ac1ddd96ea5eff267ce1a4af541c85b70efb3b2721c"
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
