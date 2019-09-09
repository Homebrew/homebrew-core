class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.2.2/irssi-1.2.2.tar.xz"
  sha256 "6727060c918568ba2ff4295ad736128dba0b995d7b20491bca11f593bd857578"
  revision 1

  bottle do
    sha256 "4661b9be4e2ded3772724234c71c325b7ac7d0060e744567e50623f27e931190" => :mojave
    sha256 "aaf5cc6be65f889e4c11f8285523b62306a09bc9a2c730d38a4ff32e4d8a1ba7" => :high_sierra
    sha256 "f3ce5bf5247d9838c025fae4554853fc737c7473406410119b1afa4005954190" => :sierra
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
  depends_on "openssl@1.1"
  uses_from_macos "perl"

  def install
    ENV.delete "HOMEBREW_SDKROOT" if MacOS.version == :high_sierra

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
    # To debug a Perl problem copy the following test at the end of the install
    # block to surface the relevant information from the build warnings.
    ENV["PERL5LIB"] = lib/"perl5/site_perl"
    system "perl", "-e", "use Irssi"
  end
end
