class Moc < Formula
  desc "Terminal-based music player"
  homepage "https://moc.daper.net/"
  revision 5

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

  bottle do
    sha256 "b15db412cd58492ce684fd50a6bec93e18cc42f5543bfd7f45fd6e5636c56291" => :mojave
    sha256 "8a570805d563e3ee3d4c374eb5a8e5d649b7364286e738f9d8bef864663073e1" => :high_sierra
    sha256 "fe941dffd41e1485f85b3d9bb28a1a30cccfe27d3cac438cc5b71fb347122003" => :sierra
    sha256 "9e39666cb49b6fd60c16b1b4535d0b39363fcc655e6495cc17d74923df13ff27" => :el_capitan
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
  depends_on "ffmpeg"
  depends_on "jack"
  depends_on "libtool"
  depends_on "ncurses"

  def install
    # Not needed for > 2.5.2
    system "autoreconf", "-fvi"
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
