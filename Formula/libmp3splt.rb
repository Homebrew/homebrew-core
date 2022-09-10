class Libmp3splt < Formula
  desc "Utility library to split mp3, ogg, and FLAC files"
  homepage "https://mp3splt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha256 "30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc"
  revision 4

  # We check the "libmp3splt" directory page since versions aren't present in
  # the RSS feed as of writing.
  livecheck do
    url "https://sourceforge.net/projects/mp3splt/files/libmp3splt/"
    strategy :page_match
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+[a-z]?)/?["' >]}i)
  end

  bottle do
    sha256 arm64_monterey: "cf6966b902ead20693e68ae083a2fcd675f141dd7da487c1a805ba0d59026c52"
    sha256 arm64_big_sur:  "6b97705dad28c30302e2e4231f36270a1c5f6f437dfa5b8f2b124ced8f278182"
    sha256 monterey:       "7805abfa8d07d0766c5857bec3e65804d33a61438e3be9df6fd17c222db142eb"
    sha256 big_sur:        "3b31e69c0b977f266caed544f809ab1982f9c5217d45ce6d09090bebf69dcd00"
    sha256 catalina:       "8b83d0965c9ea339da16b4f857dbe6c69f8c4368d714679c31396494939e9a74"
    sha256 x86_64_linux:   "8bc4f1ed2445eb596bb087cda396abccb95f42d3c28e528e88a48a993e6cdc99"
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
