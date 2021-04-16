class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.2.3/irssi-1.2.3.tar.xz"
  sha256 "a647bfefed14d2221fa77b6edac594934dc672c4a560417b1abcbbc6b88d769f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://irssi.org/download/"
    regex(%r{<p>Latest release version: <strong>v?(\d+(?:\.\d+)+)</strong>}i)
  end

  bottle do
    sha256 arm64_big_sur: "26e7ffc0a387626910476fe4c4fbed5a5006ff718edd9f087067adfe2dfb537a"
    sha256 big_sur:       "029b203b01fdde27b18fc9646980d45df551048614e14f5879a90d8914ae9255"
    sha256 catalina:      "954cd682c20c4a32ecc2f877b7e92202d58299a825c3910867223703f0e2c402"
    sha256 mojave:        "d8b4a41cf599842e56b1eacf4cc0557395e117cbf20ff733a3f764e457b6b296"
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
