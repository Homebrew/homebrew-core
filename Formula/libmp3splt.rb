class Libmp3splt < Formula
  desc "Utility library to split mp3, ogg, and FLAC files"
  homepage "https://mp3splt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha256 "30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc"

  bottle do
    sha256 "bd099b1f7f07b73c0ba90a0d506a5c169f9197abc3c0c2d787725f3c36262e94" => :mojave
    sha256 "08c048a165564eab43d0ec34f837309eec4bc5fd9f63ef80177c1d2da72c1d47" => :high_sierra
    sha256 "e513672ee4682c1f722e710d4446fc2721325875acb65ccaaee0e5de113cb82b" => :sierra
    sha256 "587226a840b162aeef70cc8022bdbcd61218e1be6dd1b98418774f3f48405072" => :el_capitan
    sha256 "47d3aaeee6d237273e8457666cd2717e1264742ae776d541c40a203e1b82003f" => :yosemite
    sha256 "0bac13f95cb16925fe28cd1d662bec10a66c93bf9b27c2c9533ab38b7a1f38a2" => :mavericks
    sha256 "a6100bee5fe14afed4702b474360078b75bddaa0328290b2fcf902c3f808c78c" => :mountain_lion
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
