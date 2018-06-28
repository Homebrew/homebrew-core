class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.16.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.16.tar.gz"
  sha256 "c8a18bc6259da0c3eefefb018f8aa298fddc6f86c6fc0f0dec73270896ab512f"

  bottle do
    cellar :any
    sha256 "04899aebecf79de7b1a1fd56ea2c57443bb8a3b4741e006c38c233554ccb0672" => :high_sierra
    sha256 "aeb282fe2d4fbee1f056b7da013db3355ee8644979bcb55cbdd97f8bc21fe240" => :sierra
    sha256 "826e5048722eb9ba535b8b3da24b0cb93fe7a3a47a19b1f034c40ffbb85304b8" => :el_capitan
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
