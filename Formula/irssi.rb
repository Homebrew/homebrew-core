class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.2.3/irssi-1.2.3.tar.xz"
  sha256 "a647bfefed14d2221fa77b6edac594934dc672c4a560417b1abcbbc6b88d769f"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://irssi.org/download/"
    regex(%r{<p>Latest release version: <strong>v?(\d+(?:\.\d+)+)</strong>}i)
  end

  bottle do
    sha256 arm64_monterey: "6f90ced76f4dff3f6a4a65f47cdb996dc8e0473c677a4ae939019c54e69c88a8"
    sha256 arm64_big_sur:  "745a8f336278ed4d2ccb4f7a396b8dd3b8cb6ac4b8cc20ae9e39822815aeb01b"
    sha256 monterey:       "e8842954b54c584b9669ba93f2a9717edb536dca7c06f0bc9ef5703a701e1c25"
    sha256 big_sur:        "837696228d18006f66c7669f3bc64daf8425d07231ffd33650ca0cf3754e63bd"
    sha256 catalina:       "4906dd3fa6634f850b5c5bbcef90288f7e005401de43a5de144bdf824a93d1ba"
    sha256 mojave:         "e24824148ee68afeb363aaae3db05a4fb30cb632416d04bd18c4763be8ae95b7"
    sha256 x86_64_linux:   "20589844282f32a4ddeb87db55f9a8fcbfd890fa0d0d3ff2d42f639cdbed2383"
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
