class Moc < Formula
  desc "Terminal-based music player"
  homepage "https://moc.daper.net/"
  revision 6

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
    sha256 arm64_monterey: "ede1647dc7294609486c67127f1038eed89089ecb0a412f4b28315f21e1d0381"
    sha256 arm64_big_sur:  "e0d4300414cfc0e63102cc677b8f5b9760c6a5c85796348f95d21d2909dd06d9"
    sha256 monterey:       "b6359e887ac7f9c6c0b4a882258b0486e401ecb98a1c55ab325940e34bb4091a"
    sha256 big_sur:        "a039c169c94918fe290d154eba80cd6075c685ddf89e0e37caa28c208ae1e19c"
    sha256 catalina:       "aa76f7971087c19de921c2d2722f4734f222d252f7fc4e4d2c5684fe5efe3638"
    sha256 x86_64_linux:   "7a3ca44601779ec514d831971f2aae1097639aaae2a96cfc3aec27c55ac44239"
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
