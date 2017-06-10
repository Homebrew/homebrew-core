class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.0.3/irssi-1.0.3.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/irsssi_1.0.3.orig.tar.xz"
  sha256 "838220297dcbe7c8c42d01005059779a82f5b7b7e7043db37ad13f5966aff581"

  bottle do
    sha256 "abf418d0c17b0e98989acafa80bd89f07971f7bef285776f1358d796650115c0" => :sierra
    sha256 "d04a543e388e597c4d3e9b5467b73fb248b42acad44eeeca9aea7aedfb3daaa2" => :el_capitan
    sha256 "5cb78bb83aec152cc88e8916e7a0739c914a2efa4dc9c7b39dc0bf20e85d984a" => :yosemite
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
