class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "http://lnav.org"
  url "https://github.com/tstack/lnav/releases/download/v0.8.1/lnav-0.8.1.tar.gz"
  sha256 "db942abccdb5327d7594ca9e32e0b44802790fad8577bdbed44f81220fd62153"

  bottle do
    rebuild 1
    sha256 "c8a5b93c1995c7dd6bc65bd93ff87b766d7e51af31e13cd1dadef0650e2c42f6" => :sierra
    sha256 "382301cd4f6bbf7f1161cbe602f89933c622890a1e992b103f2f5de6f98b353a" => :el_capitan
    sha256 "46e86d46607c0a8dc876354eecb08cb3b6216f33f7fc13f83a330288c521ba04" => :yosemite
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "readline"
  depends_on "pcre"
  depends_on "curl" => ["with-libssh2", :optional]

  def install
    # Fix errors such as "use of undeclared identifier 'sqlite3_value_subtype'"
    ENV.delete("SDKROOT")

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]

    # OS X ships with libcurl by default, albeit without sftp support. If we
    # want lnav to use the keg-only curl formula that we specify as a
    # dependency, we need to pass in the path.
    args << "--with-libcurl=#{Formula["curl"].opt_lib}" if build.with? "curl"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
