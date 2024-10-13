class Moc < Formula
  desc "Terminal-based music player"
  homepage "https://moc.daper.net/"
  license "GPL-2.0-or-later"
  revision 8

  stable do
    url "https://ftp.daper.net/pub/soft/moc/stable/moc-2.5.2.tar.bz2"
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
    sha256 arm64_sequoia:  "00f4a5601d8f7d75cf8ac0dfccd99960c64b125c02b815177261440134b80302"
    sha256 arm64_sonoma:   "3d2be9bbd88ca175407d8852d2711796d4b391202a418a8e7eecafd3cd92ec03"
    sha256 arm64_ventura:  "161367cc683c8292aaaebd85805f1b4f57f56b4345d94932e96fb6357597718b"
    sha256 arm64_monterey: "93c436057264891cfab1658f79b6b33192755107c5619e0d1f34a9556812d614"
    sha256 sonoma:         "7fd5ca668b20ddb6ff8f6b25871de75e8d0ac1fff3a50032a960c9b709a2ec11"
    sha256 ventura:        "e6759d0aaebfaa03fea50065da4cc6e12b66192191821abb274ec6769d46bfbc"
    sha256 monterey:       "88b28596fd214730528be0c8ec3d6f5af13808bcd222ada7455d8c256c28294e"
    sha256 x86_64_linux:   "5226928bc5fe64461826f8d4ac78ee53212e1065a5acf656753077eb9863b886"
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
  depends_on "berkeley-db@5"
  depends_on "ffmpeg@4" # FFmpeg 5 issue: https://moc.daper.net/node/3644
  depends_on "flac"
  depends_on "jack"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libtool"
  depends_on "libvorbis"
  depends_on "ncurses"
  depends_on "speex"

  on_linux do
    depends_on "alsa-lib"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # Not needed for > 2.5.2
    system "autoreconf", "--force", "--install", "--verbose"
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
