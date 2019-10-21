class Libopendkim < Formula
  desc "Implementation of Domain Keys Identified Mail authentication"
  homepage "http://opendkim.org"
  url "https://downloads.sourceforge.net/project/opendkim/opendkim-2.10.3.tar.gz"
  sha256 "43a0ba57bf942095fe159d0748d8933c6b1dd1117caf0273fa9a0003215e681b"
  revision 2

  bottle do
    cellar :any
    sha256 "76268e02f90b0931a9fd8d2ae933d334c2efb9ee34dc85c77d8eecc25b48c68b" => :mojave
    sha256 "e5d79e2cd539dff2a02ac91b171b23c0c36d7d012d2a3d21af1cbd732c2ee58a" => :high_sierra
    sha256 "33a66999fc2479cd6d0d27d2189ed34125e2510afb7afe0c97cdb08ed67efc95" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "unbound"

  # Patch for compatibility with OpenSSL 1.1.1
  # https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=223568
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f6a7c8c8336e4d2e7dae399995618da2b0b018e6/libopendkim/openssl-1.1.diff"
    sha256 "e7273dd866c7af6b9c828d6e94ce98d666dbc61f66d0f486aadd6934fc71ba02"
  end

  def install
    # Recreate configure due to patch
    system "autoreconf", "-fvi"

    # --disable-filter: not needed for the library build
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-filter",
                          "--with-unbound=#{Formula["unbound"].opt_prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/opendkim-genkey", "--directory=#{testpath}"
    assert_predicate testpath/"default.private", :exist?
    assert_predicate testpath/"default.txt", :exist?
  end
end
