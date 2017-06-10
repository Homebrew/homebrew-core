class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.0.3/irssi-1.0.3.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/irsssi_1.0.3.orig.tar.xz"
  sha256 "838220297dcbe7c8c42d01005059779a82f5b7b7e7043db37ad13f5966aff581"

  bottle do
    sha256 "584fb9fa0ac29318e8796551919174eb4bb33a40cf3fe99a669cb46040f54b0d" => :sierra
    sha256 "05bf4a24f5316e0b1bb00982c61a6398ebccf2c00001110d3b364168d54ea891" => :el_capitan
    sha256 "dc0762cf3e048ac95b30a1dd904da71b5e0227136858eedb11fadfd003628748" => :yosemite
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
