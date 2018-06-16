class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.15.tar.gz"
  sha256 "f9fde3207f67ed8a5a5ddd8ad5e7acf7b27c2cf0f20dfbdde876dcd6e3d2dc0e"

  bottle do
    cellar :any
    sha256 "72e9246d6863e40f2a552113ded63acb544ff1be01b362f5bbb738f92a2bf7da" => :high_sierra
    sha256 "ea9588f15f24f3fc82dda8d41f669df639787481f3a7a3663e4b0f384ae7251f" => :sierra
    sha256 "31da3139f5dc5bb66d02c3e677b9f975a2fd2f74ff1a8a6cb6468f39eb7d7e8d" => :el_capitan
  end

  option "with-libgdbm-compat", "Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."

  # Use --without-readline because readline detection is broken in 1.13
  # https://github.com/Homebrew/homebrew-core/pull/10903
  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --without-readline
      --prefix=#{prefix}
    ]

    args << "--enable-libgdbm-compat" if build.with? "libgdbm-compat"

    system "./configure", *args
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match /2/, pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
