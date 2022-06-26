class Libmp3splt < Formula
  desc "Utility library to split mp3, ogg, and FLAC files"
  homepage "https://mp3splt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha256 "30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc"
  revision 2

  # We check the "libmp3splt" directory page since versions aren't present in
  # the RSS feed as of writing.
  livecheck do
    url "https://sourceforge.net/projects/mp3splt/files/libmp3splt/"
    strategy :page_match
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+[a-z]?)/?["' >]}i)
  end

  bottle do
    sha256 arm64_monterey: "213b94e57817c97d30aacc1c7d952b0da63d2d6405fd10668d566e609446558a"
    sha256 arm64_big_sur:  "e0d52aaeb5d9708482c4f5677e17bac67ffada7b3222aea93751ccb0f56e8b5d"
    sha256 monterey:       "fe867e20a444aee1d3a8435aa8acfb6e720e18a90131c00c63a2b9bfb9617d14"
    sha256 big_sur:        "7ac2ea2f110f98de99d3c36702fe4a4113e6d0feaacecad442f67adcf5c0f827"
    sha256 catalina:       "d3f9e3a5e41a1e6f22c514dee13693926f3b5d35394376dd87b0753f1dea6a03"
    sha256 x86_64_linux:   "ea6dbb01f6511003d4e5c54616c19397c6500a9230070f73255493951f6d3416"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libtool"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "pcre"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
