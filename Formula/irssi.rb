class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.0.2/irssi-1.0.2.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/irssi/irssi_1.0.2.orig.tar.xz"
  sha256 "5c1c3cc2caf103aad073fadeb000e0f8cb3b416833a7f43ceb8bd9fcf275fbe9"

  bottle do
    sha256 "584a3fce1c417ce190b0d7bc956a73244b7becd64da91b367e81ca3f3e387887" => :sierra
    sha256 "2a3ea4ea9cf1ae9340634138834eed249d0a960a81f7a2d3a07cf5febdc6e91b" => :el_capitan
    sha256 "ba8ce35490ca58ffdc001dc352a04d23b2e849bbd3229f073e3224d8bbd258c4" => :yosemite
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
