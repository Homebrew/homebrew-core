class Moc < Formula
  desc "Terminal-based music player"
  homepage "https://moc.daper.net/"
  license "GPL-2.0-or-later"
  revision 7

  stable do
    url "http://ftp.daper.net/pub/soft/moc/stable/moc-2.5.2.tar.bz2"
    sha256 "f3a68115602a4788b7cfa9bbe9397a9d5e24c68cb61a57695d1c2c3ecf49db08"

    # Remove for > 2.5.2; FFmpeg 4.0 compatibility
    # 01 to 05 below are backported from patches provided 26 Apr 2018 by
    # upstream's John Fitzgerald
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/01-codec-2.5.2.patch"
      sha256 "c6144dbbd85e3b775e3f03e83b0f90457450926583d4511fe32b7d655fdaf4eb"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/02-codecpar-2.5.2.patch"
      sha256 "5ee71f762500e68a6ccce84fb9b9a4876e89e7d234a851552290b42c4a35e930"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/03-defines-2.5.2.patch"
      sha256 "2ecfb9afbbfef9bd6f235bf1693d3e94943cf1402c4350f3681195e1fbb3d661"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/04-lockmgr-2.5.2.patch"
      sha256 "9ccfad2f98abb6f974fe6dc4c95d0dc9a754a490c3a87d3bd81082fc5e5f42dc"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/05-audio4-2.5.2.patch"
      sha256 "9a75ac8479ed895d07725ac9b7d86ceb6c8a1a15ee942c35eb5365f4c3cc7075"
    end
  end

  livecheck do
    url "https://moc.daper.net/download"
    regex(/href=.*?moc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d384eac5db501bffc4ca293814999bd211a30aa8d8c51608264c141ecae0e588"
    sha256 arm64_monterey: "76a10d22e284b7082d386b7850b228ba8c7b8a39e0af5fe8dd3bfda8ee5e8504"
    sha256 arm64_big_sur:  "748bce503189849012269695eaa9da403d63944d480b5f65912efd30abe75937"
    sha256 ventura:        "e1d9b0a8885b048bef641d9e5dde6d7be8cdfd007a93f1abc86b67cafa8152e6"
    sha256 monterey:       "3ef692dc6ca98b8613faab3346997a9bf908180569ef437404c1fe2183d8c414"
    sha256 big_sur:        "38313bf01863d64276c647565074618b71e09cd3b4a7dc0121b606dd52b534ad"
    sha256 catalina:       "15e7bfdbd9e0c3726962278c05ca09e646bf4fd748a5107f103f8133b7bfc3f9"
    sha256 x86_64_linux:   "c5dcdab691336c5c529fca538c46a26874e7bb92da1d9a803265f89b83720336"
  end

  head do
    url "svn://daper.net/moc/trunk"

    depends_on "popt"
  end

  # Remove autoconf, automake and gettext for > 2.5.2
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "ffmpeg@4"
  depends_on "jack"
  depends_on "libtool"
  depends_on "ncurses"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # Not needed for > 2.5.2
    system "autoreconf", "-fvi"
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    "You must start the jack daemon prior to running mocp."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mocp --version")
  end
end
