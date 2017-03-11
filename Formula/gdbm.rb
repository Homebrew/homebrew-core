class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftpmirror.gnu.org/gdbm/gdbm-1.13.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gdbm/gdbm-1.13.tar.gz"
  sha256 "9d252cbd7d793f7b12bcceaddda98d257c14f4d1890d851c386c37207000a253"

  bottle do
    cellar :any
    sha256 "ffe92893d1d2d331e749be3e6f530de13b598adb7ebfe95eaea81e2d0ccbf0ce" => :sierra
    sha256 "80ee188768a6029012a576c29be718149378d058e1803c6149ee8a36ce879f58" => :el_capitan
    sha256 "fa512dd57e18dc3db293cfcf305356d137a3fad0f85240a9788dc4057290ce9c" => :yosemite
    sha256 "87bfecf948e8b6182519f627f95c244531b2a48c1941352bee0980275b515f43" => :mavericks
  end

  option "with-libgdbm-compat", "Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."

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
    assert File.exist?("test")
    assert_match /2/, pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
