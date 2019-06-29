class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.2.1/irssi-1.2.1.tar.xz"
  sha256 "5466a1ed9612cfa707d9a37d60b29d027b4ac7d83c74ceb1a410e2b59edba92c"

  bottle do
    sha256 "7e5b4748f6cbf3cd92f5981aff4ac68bbea75cab1ff4ba8a102774053ec82d41" => :mojave
    sha256 "d74dccec46a3cbab24126dc7f3be346b05caa50bdf492e9196a0fda15ad0a2fa" => :high_sierra
    sha256 "70d8c2802625e36774aba6762d31adae082eef57e690dd0e1feb4f836a6fb5fc" => :sierra
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
