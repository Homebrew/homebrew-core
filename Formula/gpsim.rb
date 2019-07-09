class Gpsim < Formula
  desc "Simulator for Microchip's PIC microcontrollers"
  homepage "https://gpsim.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gpsim/gpsim/0.31.0/gpsim-0.31.0.tar.gz"
  sha256 "110ee6be3a5d02b32803a91e480cbfc9d423ef72e0830703fc0bc97b9569923f"
  head "https://svn.code.sf.net/p/gpsim/code/trunk"

  bottle do
    cellar :any
    sha256 "b23f55ef987950a2ce33fa689285df2cb52c0c1a312be6444d2b1f85133c3592" => :mojave
    sha256 "88f1632b32bdf93cde134af323bd3fb6baf948d6d37cf85209faed9c32a39ab2" => :high_sierra
    sha256 "9a921c9394e0ed524f8f2fd8ec4a1433decce6fcf342a8da6d5e30c04885ffed" => :sierra
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
