class Libmp3splt < Formula
  desc "Utility library to split mp3, ogg, and FLAC files"
  homepage "https://mp3splt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha256 "30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc"
  revision 1

  # We check the "libmp3splt" directory page since versions aren't present in
  # the RSS feed as of writing.
  livecheck do
    url "https://sourceforge.net/projects/mp3splt/files/libmp3splt/"
    strategy :page_match
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+[a-z]?)/?["' >]}i)
  end

  bottle do
    sha256 arm64_monterey: "01d1c1db0b527666e95027cb7e071f60219a055cbd7626606bff727ed34c93df"
    sha256 arm64_big_sur:  "fcda51b514df7925e6503cda320f8a98b03a588b99cd89612b1ef466eb608f89"
    sha256 monterey:       "d92c8799e935c0875361f86a805ff55392f6fc173f612c2e1cd5d28c07e3564b"
    sha256 big_sur:        "55d3fdb8d59c595093e53b18d1d07f43ae80a41aa73ec228e9984fc919884faf"
    sha256 catalina:       "8070118d4ad4175f51c60081fcc01193b494c8f5e96ed7cf82364f73d68754e3"
    sha256 mojave:         "d929bb92be95a49b808d087be5e88100bc23c423100da1afd86422cf0ed3d6cb"
    sha256 high_sierra:    "71eb2ec5137acc03b95dbfdfadbb88c6bade2cb1548cce2655876971e346707a"
    sha256 sierra:         "805407189fbd468b036493996832e387395380a2fbda743cafac78876632abf9"
    sha256 x86_64_linux:   "6d4db5e0f6316197290c54c8a74a3594ffab7917c7de502aace6e09ce5117597"
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
