class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "http://lnav.org"
  url "https://github.com/tstack/lnav/releases/download/v0.8.1/lnav-0.8.1.tar.gz"
  sha256 "db942abccdb5327d7594ca9e32e0b44802790fad8577bdbed44f81220fd62153"

  bottle do
    sha256 "5eb0e048b35a7ee79b36691ca0678163961ee8f3e8c5841e88c90cf69a07b41c" => :el_capitan
    sha256 "35bf1e6722eed4c8a1c5bdffbce5fed4257ff5aee1eb1e3c54208e9392a32b21" => :yosemite
    sha256 "fdcbbcf3db3cffd0aa7ae5d4c9c1320beb8a35a0f3f66f18f32ff675ea3d9418" => :mavericks
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
