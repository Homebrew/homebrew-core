class Moc < Formula
  desc "Terminal-based music player"
  homepage "https://moc.daper.net/"
  url "http://ftp.daper.net/pub/soft/moc/stable/moc-2.5.2.tar.bz2"
  sha256 "f3a68115602a4788b7cfa9bbe9397a9d5e24c68cb61a57695d1c2c3ecf49db08"
  revision 3

  bottle do
    sha256 "6885bcf2c1b9d983da98b574679238233e8f72b11835838a60ccb193769661e4" => :high_sierra
    sha256 "9a83617fd712f2c96079b192f1554345e1a89b1592d5f9dd60be1d229952303f" => :sierra
    sha256 "4b578375503665ec52c8810eb4cfc48ef9608fc5fe387a29f0deb98a631e659d" => :el_capitan
  end

  devel do
    url "http://ftp.daper.net/pub/soft/moc/unstable/moc-2.6-alpha3.tar.xz"
    sha256 "a27b8888984cf8dbcd758584961529ddf48c237caa9b40b67423fbfbb88323b1"

    # Patch for clock_gettime issue
    # https://moc.daper.net/node/1576
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/78d5908905c6848bb75ae41b70d6bbb46abaa69b/moc/r2936-clock_gettime.patch"
      sha256 "601b5cdf59db67f180f1aaa6cc90804c1cb69c44cdecb2e8149338782e4f21a8"
    end

    # Remove build deps when 2.6-alpha4 comes out
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "popt"
  end

  head do
    url "svn://daper.net/moc/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "popt"
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "ffmpeg"
  depends_on "jack"
  depends_on "libtool"
  depends_on "ncurses"

  # FFmpeg 4.0 compatibility
  # Reported 26 Apr 2018 to mocmaint AT daper DOT net
  patch :p0 do
    url "https://git.archlinux.org/svntogit/packages.git/plain/trunk/moc-ffmpeg4.patch?h=packages/moc"
    sha256 "f1a12d7d2e8269974487a2ffb011e87d9a6c5c06e2a47d1312d5965c98f050ea"
  end

  def install
    # Remove build.devel? when 2.6-alpha4 comes out
    system "autoreconf", "-fvi" if build.head? || build.devel?
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      You must start the jack daemon prior to running mocp.
      If you need wide-character support in the player, for example
      with Chinese characters, you can install using
          --with-ncurses
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mocp --version")
  end
end
