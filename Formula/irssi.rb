class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.2.0/irssi-1.2.0.tar.xz"
  sha256 "1643fca1d8b35e5a5d7b715c9c889e1e9cdb7e578e06487901ea959e6ab3ebe5"

  bottle do
    rebuild 1
    sha256 "789041b9cbd74bbae92962e2846baf463ba57b0ae6e94f4dba83f718253223ef" => :mojave
    sha256 "d8a0ff73163c24d2d93bd4b030fa46d22ba7ecb4b27e0bbc604b1877e0298122" => :high_sierra
    sha256 "644e818a4e6718eea2ff0bebf5c8749aa3df552d4a24be6b109e95452b255942" => :sierra
    sha256 "8716dafbb112103d73edb9b9463eb063e59217eb7e32c3676eac05cc420ca42d" => :el_capitan
  end

  head do
    url "https://github.com/irssi/irssi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bot
      --with-proxy
      --enable-true-color
      --with-socks=no
      --with-ncurses=#{MacOS.sdk_path}/usr
      --with-perl=yes
      --with-perl-lib=#{lib}/perl5/site_perl
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh", *args
    end

    # https://github.com/irssi/irssi/pull/927
    # inreplace "configure", "^DUIfm", "^DUIifm"

    system "./configure", *args
    # "make" and "make install" must be done separately on some systems
    system "make"
    system "make", "install"
  end

  test do
    IO.popen("#{bin}/irssi --connect=irc.freenode.net", "w") do |pipe|
      pipe.puts "/quit\n"
      pipe.close_write
    end

    # This is not how you'd use Perl with Irssi but it is enough to be
    # sure the Perl element didn't fail to compile, which is needed
    # because upstream treats Perl build failures as non-fatal.
    ENV["PERL5LIB"] = lib/"perl5/site_perl"
    system "perl", "-e", "use Irssi"
  end
end
