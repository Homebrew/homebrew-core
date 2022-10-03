class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.2.3/irssi-1.2.3.tar.xz"
  sha256 "a647bfefed14d2221fa77b6edac594934dc672c4a560417b1abcbbc6b88d769f"
  license "GPL-2.0-or-later"
  revision 3

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "a9cf2441cb3eccfbe05a2fdcb75b92cb6d49360ce4f70f3e4e8f3b315b5c5e7f"
    sha256 arm64_big_sur:  "f9b916bdbeb562a0581ea29038c425b236495e62f64fbbf813f142755e3ca56d"
    sha256 monterey:       "6257cfbc34b5501397c41d07ad2d5bfb2c151c6f31e0d7c8ca33917da50b0ee7"
    sha256 big_sur:        "ab7e834920115f440fa9785cfa3da93eed3a05167530823e81115db886b0f68e"
    sha256 catalina:       "1761863c0d487a2f0c12dcb3e334d1b885efb9c5d75f8e9dbdd53448a238b397"
    sha256 x86_64_linux:   "9794cd9b7e88d94b3f4701947d8deb0004267a241cf72d1886645246ad7f6ff5"
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

    args << if OS.mac?
      "--with-ncurses=#{MacOS.sdk_path/"usr"}"
    else
      "--with-ncurses=#{Formula["ncurses"].prefix}"
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
