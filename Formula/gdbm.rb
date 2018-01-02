class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.14.tar.gz"
  sha256 "ada1437a4165a707b3e9f37b5b74dbbe7c2f8bde633b8c2c7dbc8f84f39baa09"

  bottle do
    cellar :any
    sha256 "f7cbf71be7e38ab6268c3c403e03cf4af6a4e5a51f3086999b336bf5fb6820d0" => :high_sierra
    sha256 "d9a0a56daeedacb01d12e2ad8612e66bed5a4175658d3b1166062a61d744fe8d" => :sierra
    sha256 "713b714c182309d8d63ebeb3aae7cac6a7d6dfb35ea39a0c890cb639f789e337" => :el_capitan
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
