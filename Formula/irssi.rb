class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  license "GPL-2.0-or-later"

  stable do
    # We can switch back to a tarball after the next release;
    # irssi's autogen refuses to work from a tarball
    url "https://github.com/irssi/irssi.git",
        tag:      "1.2.3",
        revision: "91dc3e4dfa1a9558c5a7fe0ea982cb9df0e2de65"

    # Backports an upstream patch which disables some autoconf behaviour;
    # prerequisite for the next patch to work.
    # https://github.com/irssi/irssi/pull/1268
    patch do
      url "https://github.com/Homebrew/formula-patches/raw/467f95fcd0438b5f7a88ae0c406a8f73bc93b501/irssi/nostdinc.diff"
      sha256 "00a7fe5e796ec3e37d629e0484f08f23b0fa33a428088d120ac0d8283054449c"
    end

    # Backports a patch which adjusts how irssi uses curses headers,
    # required for it to work properly on Apple silicon.
    # https://github.com/irssi/irssi/pull/1290
    patch do
      url "https://github.com/Homebrew/formula-patches/raw/467f95fcd0438b5f7a88ae0c406a8f73bc93b501/irssi/curses_check.patch"
      sha256 "a505394680e518712e9d0ab0ff14622d34b633b8310dbbfa42b5ad1df7fd3050"
    end
  end

  livecheck do
    url "https://irssi.org/download/"
    regex(%r{<p>Latest release version: <strong>v?(\d+(?:\.\d+)+)</strong>}i)
  end

  bottle do
    sha256 arm64_big_sur: "668c92b2a9730bd0617bb17ee6f3b405706d13d2c88678da082a55a13a9149f0"
    sha256 big_sur:       "4b3a1a552013ec99c97142d07b596d6dd2bdec87b52190179e5a3bdc9fd99f59"
    sha256 catalina:      "6962eb1f607332ce8319c55febe94c419376878b1fc30738f3e05aaa24355ea4"
    sha256 mojave:        "1da2e8798d530cbc6c7f901651df3f9a24168b61b856fc8b8100796fd66e239f"
  end

  head do
    url "https://github.com/irssi/irssi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  # Needed while we're regenerating configure due to the patch
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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

    # Restore this to an `if build.head?` conditional
    # once we no longer need the patch
    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh", *args

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
