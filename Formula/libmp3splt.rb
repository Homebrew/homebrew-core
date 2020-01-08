class Libmp3splt < Formula
  desc "Utility library to split mp3, ogg, and FLAC files"
  homepage "https://mp3splt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha256 "30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc"
  revision 1

  bottle do
    sha256 "8070118d4ad4175f51c60081fcc01193b494c8f5e96ed7cf82364f73d68754e3" => :catalina
    sha256 "d929bb92be95a49b808d087be5e88100bc23c423100da1afd86422cf0ed3d6cb" => :mojave
    sha256 "71eb2ec5137acc03b95dbfdfadbb88c6bade2cb1548cce2655876971e346707a" => :high_sierra
    sha256 "805407189fbd468b036493996832e387395380a2fbda743cafac78876632abf9" => :sierra
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
