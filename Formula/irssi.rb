class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.0.4/irssi-1.0.4.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/irsssi_1.0.4.orig.tar.xz"
  sha256 "b85c07dbafe178213eccdc69f5f8f0ac024dea01c67244668f91ec1c06b986ca"

  bottle do
    sha256 "aab6ebcbe1bbbee5aa0958caa9adbc018462651437f77d214c33f06dbdb5494f" => :sierra
    sha256 "cacc37fef6a832d7ee0be25f6e82c034e170756e870169c376748e0dab8fc805" => :el_capitan
    sha256 "d53637d6473c7f344ba3c51ee556f85e402de0a8ccf211efb30437ed79fc62e2" => :yosemite
  end

  head do
    url "https://github.com/irssi/irssi.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  option "with-dante", "Build with SOCKS support"
  option "without-perl", "Build without perl support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl" => :recommended
  depends_on "dante" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bot
      --with-proxy
      --enable-true-color
      --with-socks=#{build.with?("dante") ? "yes" : "no"}
      --with-ncurses=#{MacOS.sdk_path}/usr
    ]

    if build.with? "perl"
      args << "--with-perl=yes"
      args << "--with-perl-lib=#{lib}/perl5/site_perl"
    else
      args << "--with-perl=no"
    end

    args << "--disable-ssl" if build.without? "openssl"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    # "make" and "make install" must be done separately on some systems
    system "make"
    system "make", "install"
  end

  test do
    IO.popen("#{bin}/irssi --connect=irc.freenode.net", "w") do |pipe|
      pipe.puts "/quit\n"
      pipe.close_write
    end
  end
end
