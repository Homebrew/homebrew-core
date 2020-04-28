class NestopiaUe < Formula
  desc "Nestopia UE (Undead Edition): NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://github.com/0ldsk00l/nestopia/archive/1.50.tar.gz"
  sha256 "f0274f8b033852007c67237897c69725b811c0df8a6d0120f39c23e990662aae"
  head "https://github.com/0ldsk00l/nestopia.git"

  bottle do
    sha256 "64ca845207bcc0dbb8b9163aed6b60956f50dd707bd705850a11694566c8762a" => :catalina
    sha256 "8c13d064015561a0707b4f47989d193527773af0021cbae1120b53d6a688ad20" => :mojave
    sha256 "2be015b071a5d17bd3a28aa2348949eeb91659c94efa12226adff66e8934356d" => :high_sierra
    sha256 "148a7754f387640b112f447327d23322e9d43b938d7aba9a584c311850fc284c" => :sierra
    sha256 "43b5dd65950c2bf19aebbb77f307e96933557597379b83023fd3914a26d4666c" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libarchive"
  depends_on "libepoxy"
  depends_on "sdl2"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{pkgshare}"
    system "make", "install"
  end

  test do
    assert_match /Nestopia UE #{version}$/, shell_output("#{bin}/nestopia --version")
  end
end
