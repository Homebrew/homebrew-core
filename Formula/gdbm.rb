class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "http://ftpmirror.gnu.org/gdbm/gdbm-1.12.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gdbm/gdbm-1.12.tar.gz"
  sha256 "d97b2166ee867fd6ca5c022efee80702d6f30dd66af0e03ed092285c3af9bcea"

  bottle do
    cellar :any
    sha256 "80ee188768a6029012a576c29be718149378d058e1803c6149ee8a36ce879f58" => :el_capitan
    sha256 "fa512dd57e18dc3db293cfcf305356d137a3fad0f85240a9788dc4057290ce9c" => :yosemite
    sha256 "87bfecf948e8b6182519f627f95c244531b2a48c1941352bee0980275b515f43" => :mavericks
  end

  option :universal
  option "with-libgdbm-compat", "Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
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
