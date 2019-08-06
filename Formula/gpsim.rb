class Gpsim < Formula
  desc "Simulator for Microchip's PIC microcontrollers"
  homepage "https://gpsim.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gpsim/gpsim/0.31.0/gpsim-0.31.0.tar.gz"
  sha256 "110ee6be3a5d02b32803a91e480cbfc9d423ef72e0830703fc0bc97b9569923f"
  head "https://svn.code.sf.net/p/gpsim/code/trunk"

  bottle do
    cellar :any
    sha256 "00c585480ada4e552a32ee3f0e11bc68142ce4f6671eeb14badc51007d07be9f" => :mojave
    sha256 "612ce9c2f03a5c6464aee9b9bdcd6884e434e457f515bbbc2adceb8417f1c6d1" => :high_sierra
    sha256 "5a366b0dccfe1ff92aaed6d29f9bd5ca66806471b17e8941206e985f6bd8817a" => :sierra
  end

  depends_on "gputils" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"
  depends_on "readline"

  def install
    ENV.cxx11

    # Upstream bug filed: https://sourceforge.net/p/gpsim/bugs/245/
    inreplace "src/modules.cc", "#include \"error.h\"", ""

    system "./configure", "--disable-dependency-tracking",
                          "--disable-gui",
                          "--disable-shared",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
  end

  test do
    system "#{bin}/gpsim", "--version"
  end
end
