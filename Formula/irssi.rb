class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.2.3/irssi-1.2.3.tar.xz"
  sha256 "a647bfefed14d2221fa77b6edac594934dc672c4a560417b1abcbbc6b88d769f"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 4

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "576bb2c88cfb864583baceea72d246f5489ee0f2d17a4b2cedefa76253e2c46a"
    sha256 arm64_monterey: "d83017d9cda2ad73f077be22ffd08f157155d34968ba6eecf58a7b0e4c4c6d6e"
    sha256 arm64_big_sur:  "66f1399d3bd85d0b76916ec1e0d4a6a97a9964ca3b045c6763b9c348aa35a5df"
    sha256 ventura:        "0daaf3870649fe1ce73f9fe31c817b9a4f04f2a52dd84b14ff0d77c135dde74c"
    sha256 monterey:       "c75221cd7c3d4110f9661357d00ced37fc649bfac71408910a77fcd16260ce30"
    sha256 big_sur:        "5b3ee4f68f6126a3daf7a1c1c5867b8ae9c401f7796b416944c2f1d36cb33976"
    sha256 x86_64_linux:   "7f06f06ed9c12a97f710a690865d0b549fd88ab346c49876bdfe7f56fea1c27c"
  end

  head do
    url "https://github.com/irssi/irssi.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@3"

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
