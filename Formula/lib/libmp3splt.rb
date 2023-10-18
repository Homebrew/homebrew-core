class Libmp3splt < Formula
  desc "Utility library to split mp3, ogg, and FLAC files"
  homepage "https://mp3splt.sourceforge.net/mp3splt_page/home.php"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha256 "30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc"
  revision 4

  # We check the "libmp3splt" directory page since versions aren't present in
  # the RSS feed as of writing.
  livecheck do
    url "https://sourceforge.net/projects/mp3splt/files/libmp3splt/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+[a-z]?)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sonoma:   "de9ea30f0c902e349097bcbbe6efb1ecc835e50291bd618d9789d0eeeb1779ac"
    sha256 arm64_ventura:  "e95a05675241b026300fd7daf6911a139300fbaa532d753240661dc69edb718c"
    sha256 arm64_monterey: "f851c1d17d5f4b6d49baa45f1de154d14e141396429bdf5ccdf3abede2b29988"
    sha256 arm64_big_sur:  "03087be44a54352405397931121370b1ba6621ddaa920822988938e0ed0a503e"
    sha256 sonoma:         "b40d24b4b507627462a1d77b26934610bbd9b085b9c989710b1fe8b2aa9b9d3d"
    sha256 ventura:        "e70e4d3d2adfadabc9ffc01834245bf091a7d0859995754dee3fd1002482a00f"
    sha256 monterey:       "43a2c40bbbf27714e2df4812e165ce2260e06c18a9534a830d4d603e78ab6d89"
    sha256 big_sur:        "f6a8aea05d3277c8fd92efa9a9a0745475867e90cf91ab2a1157659a794d16ec"
    sha256 catalina:       "e0f8a379b1bbf68300be919e9f28c6a707639c792b8db355cb1ca76eb641630b"
    sha256 x86_64_linux:   "53af5c1f19326456730cab5b268e2574c56a24f0276795296916206e8d3485e9"
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
