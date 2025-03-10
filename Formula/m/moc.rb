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
    sha256 arm64_sequoia: "e9223da03ee6fb8b0a003965bcc1b70eb1d1078166bbc1355b1ee2740edc1767"
    sha256 arm64_sonoma:  "bc82b57489544a590736ab42f4a1c1810cc70b9d53f5e56f180bbe2462d0ae68"
    sha256 arm64_ventura: "d5f03722679fc2b038e2f0709f47ff9281cad1b2757bd63cbd0285e3637678fc"
    sha256 sonoma:        "73e8219df52bfdcd621661fa01cb631c7036e61bc700ec162a1876f5bf5d24b0"
    sha256 ventura:       "3313aab434fb9bde3549f270b69f44ab5afe310e3414f7fec7fadde822001e2d"
    sha256 x86_64_linux:  "8111723e66986c9ad5af3c8ce31210ad50755b7f7aa31d5d31636a6bb8eaddd7"
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
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libmodplug"
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
    ENV["am_cv_func_iconv_works"] = "yes" if OS.mac? && MacOS.version == :sequoia

    # Not needed for > 2.5.2
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
