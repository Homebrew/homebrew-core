class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/0.8.20/irssi-0.8.20.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/irssi/irssi_0.8.20.orig.tar.xz"
  sha256 "7882c4e821f5aac469c5e69e69d7e235f4986101285c675e81a9a95bfb20505a"

  bottle do
    sha256 "7bf8f9d6b3962d9555de3c47e10e0f9175ffeed1b0b89a8f410bf7c386c0195e" => :sierra
    sha256 "28fc544267f2461b8aa9b55551020f7c2cb7b1aa469e9f61a510038c44651502" => :el_capitan
    sha256 "c0c9e4d5704693edb883cf5218df0f17d92ae9925ee04649723c6c28e0fa26db" => :yosemite
    sha256 "738b120106d5d76e360a083032c34456458802fc57b808e45f061bdfad3929e8" => :x86_64_linux
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
  depends_on "perl" unless OS.mac? || build.without?("perl") # for libperl.so

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bot
      --with-proxy
      --enable-ipv6
      --enable-true-color
      --with-socks=#{build.with?("dante") ? "yes" : "no"}
      --with-ncurses=#{OS.mac? ? MacOS.sdk_path/"usr" : Formula["ncurses"].prefix}
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
