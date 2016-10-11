class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "http://lnav.org"
  url "https://github.com/tstack/lnav/releases/download/v0.8.1/lnav-0.8.1.tar.gz"
  sha256 "db942abccdb5327d7594ca9e32e0b44802790fad8577bdbed44f81220fd62153"
  revision 1

  bottle do
    sha256 "6a837ec2864ded4184dbbc107ff1ae662ac3c15653612e40d7525e807f6924ee" => :sierra
    sha256 "7cebdd35ef7af9955d419831fd9a4ad3dc01a4936f2793c4b089cb4fa82060bf" => :el_capitan
    sha256 "c01ab02b88fbd581c4f956a8ca7a7190a0a31b6d3ac75977bd7cd8bbbdc491c2" => :yosemite
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
