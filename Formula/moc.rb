class Moc < Formula
  desc "Terminal-based music player"
  homepage "https://moc.daper.net/"
  url "http://ftp.daper.net/pub/soft/moc/stable/moc-2.5.2.tar.bz2"
  sha256 "f3a68115602a4788b7cfa9bbe9397a9d5e24c68cb61a57695d1c2c3ecf49db08"
  revision 2

  bottle do
    rebuild 1
    sha256 "fbabdaaaea2215a4b20636cf32f0fcf1723dbbfe3c522448c1d9bd4057ee8a7e" => :high_sierra
    sha256 "785c68d5b1657c4bd9cd5a28bf0a1707cad2e7c3b822e1571871cb42464f4844" => :sierra
    sha256 "09e0d32b7feaf0fc50e1cfe52a0692c5e514ea3f22463becd47b94a001cb8bcd" => :el_capitan
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
