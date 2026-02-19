class Moc < Formula
  desc "Terminal-based music player"
  homepage "https://moc.daper.net/"
  license "GPL-2.0-or-later"
  revision 10

  stable do
    url "https://ftp.daper.net/pub/soft/moc/stable/moc-2.5.2.tar.bz2"
    sha256 "f3a68115602a4788b7cfa9bbe9397a9d5e24c68cb61a57695d1c2c3ecf49db08"

    # Remove for > 2.5.2; FFmpeg 4.0 compatibility
    # 01 to 05 below are backported from patches provided 26 Apr 2018 by
    # upstream's John Fitzgerald
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/moc/01-codec-2.5.2.patch"
      sha256 "c6144dbbd85e3b775e3f03e83b0f90457450926583d4511fe32b7d655fdaf4eb"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/moc/02-codecpar-2.5.2.patch"
      sha256 "5ee71f762500e68a6ccce84fb9b9a4876e89e7d234a851552290b42c4a35e930"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/moc/03-defines-2.5.2.patch"
      sha256 "2ecfb9afbbfef9bd6f235bf1693d3e94943cf1402c4350f3681195e1fbb3d661"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/moc/04-lockmgr-2.5.2.patch"
      sha256 "9ccfad2f98abb6f974fe6dc4c95d0dc9a754a490c3a87d3bd81082fc5e5f42dc"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/moc/05-audio4-2.5.2.patch"
      sha256 "9a75ac8479ed895d07725ac9b7d86ceb6c8a1a15ee942c35eb5365f4c3cc7075"
    end
  end

  livecheck do
    url "https://moc.daper.net/download"
    regex(/href=.*?moc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "bac52905e18eff309f2c6ba4077a3008f1ca2f449055406f511767d881b3545a"
    sha256 arm64_sequoia: "0c9fa6831440aa41b25064c9f2d93e9827f0d4f1ea0f2e1184def14041366d1b"
    sha256 arm64_sonoma:  "f9698a87a21e1695cfc81523056a86d2a08b3ecb013b978c46b0584a2cff566e"
    sha256 arm64_ventura: "5494731a8b584382705cf06e159d10c42fd869150ab605cf4a096b2112e61d65"
    sha256 sonoma:        "4c15f75d82b37a05b79efddabd6e670076d94570d4e25a0e72a17cf72ed82d1c"
    sha256 ventura:       "f8def0f81c78bf06d1add5d086418a0522cd207cdb3ee177d5aad5b2f3ef0c26"
    sha256 arm64_linux:   "9a554bdfd055b86a978fff7d54467fcf43261c4e88c149a5f3e81bb736447074"
    sha256 x86_64_linux:  "a62b0dee94dd77f8368039d0e86b76282df94055c16cca501dcdd8ae719251f6"
  end

  head do
    url "svn://daper.net/moc/trunk"

    depends_on "popt"
  end

  # Remove autoconf, automake and gettext for > 2.5.2
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5"
  depends_on "ffmpeg@4" # FFmpeg 5 issue: https://moc.daper.net/node/3644
  depends_on "flac"
  depends_on "jack"
  depends_on "libmodplug"
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

  def install
    # macOS iconv implementation is slightly broken since Sonoma.
    # upstream bug report: https://savannah.gnu.org/bugs/index.php?66541
    ENV["am_cv_func_iconv_works"] = "yes" if OS.mac? && MacOS.version >= :sequoia

    ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"

    # Not needed for > 2.5.2
    odie "Remove `autoreconf` and dependencies!" if build.stable? && version > "2.5.2"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  def caveats
    "You must start the jack daemon prior to running mocp."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mocp --version")
  end
end
