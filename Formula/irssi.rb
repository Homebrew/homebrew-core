class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.2.2/irssi-1.2.2.tar.xz"
  sha256 "6727060c918568ba2ff4295ad736128dba0b995d7b20491bca11f593bd857578"
  license "GPL-2.0"
  revision 1

  livecheck do
    url "https://irssi.org/download/"
    regex(%r{<p>Latest release version: <strong>v?(\d+(?:\.\d+)+)</strong>}i)
  end

  bottle do
    rebuild 1
    sha256 "777daa274e6a688f4d0878b5be6b7054f5be774ff8fc8c63649aeefc48509e8d" => :big_sur
    sha256 "a10819692310e4e965cece210cc320eb31a8273b9b052ff423c01c24afce6ba7" => :arm64_big_sur
    sha256 "a8d0caa726da8abaa3942e154ea6d6501df46ea3ae7c24d3583d3a229fd92727" => :catalina
    sha256 "e25efab5dc0b20925d920aca182f713fa54b3d781bbea7ff0ff98606a29e8553" => :mojave
    sha256 "92ce3e102445bc1248daf5404b9045088dde6a8f4e185c5f2a98982e692b4b26" => :high_sierra
    sha256 "5f2f66c2581189d52bab585f5a1731f2382a29d7125d782856b6b0944515b1bd" => :sierra
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

  uses_from_macos "ncurses"
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
      --with-perl=yes
      --with-perl-lib=#{lib}/perl5/site_perl
    ]

    on_macos do
      args << "--with-ncurses=#{MacOS.sdk_path/"usr"}"
    end
    on_linux do
      args << "--with-ncurses=#{Formula["ncurses"].prefix}"
    end

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
