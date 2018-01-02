class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.14.tar.gz"
  sha256 "ada1437a4165a707b3e9f37b5b74dbbe7c2f8bde633b8c2c7dbc8f84f39baa09"

  bottle do
    cellar :any
    sha256 "48b4d3c3c2e3e1ae6f6c505aad986689b719b15a05b23cf33730b3f04818d236" => :high_sierra
    sha256 "9647a01c12d0aeddfe0a73daeed3994ccc655bb61114f3be6b54bdf982d72790" => :sierra
    sha256 "f2f5f359af6a2ecb3da54e242c43e914f4a60343dc42f13380948ebc977284dc" => :el_capitan
    sha256 "1fa21ba6e4c5dc5b5d6bf9faae3f8c8e1304a95a8bd201712d40bd4271767948" => :yosemite
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
