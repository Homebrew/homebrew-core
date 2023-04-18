class Gpsim < Formula
  desc "Simulator for Microchip's PIC microcontrollers"
  homepage "https://gpsim.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gpsim/gpsim/0.31.0/gpsim-0.31.0.tar.gz"
  sha256 "110ee6be3a5d02b32803a91e480cbfc9d423ef72e0830703fc0bc97b9569923f"
  license "GPL-2.0"
  head "https://svn.code.sf.net/p/gpsim/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/gpsim[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7c2f982e48f43bd5b4bf96bc789292d2e786be2cba23cda8b23303cb4f323ad9"
    sha256 cellar: :any,                 monterey:      "67592314e36ca6c5c0bfa338ec40ba7b2c168665bbff42f280429866da401e3c"
    sha256 cellar: :any,                 big_sur:       "65f8044f61bd55813e73385c46ec6bb167c45ac9af373d14c544cdbdff932fb4"
    sha256 cellar: :any,                 catalina:      "7f92c6ae94438c73050aea08fa41c56b93efa9464855b3b0861b0bb3c6a08621"
    sha256 cellar: :any,                 mojave:        "00c585480ada4e552a32ee3f0e11bc68142ce4f6671eeb14badc51007d07be9f"
    sha256 cellar: :any,                 high_sierra:   "612ce9c2f03a5c6464aee9b9bdcd6884e434e457f515bbbc2adceb8417f1c6d1"
    sha256 cellar: :any,                 sierra:        "5a366b0dccfe1ff92aaed6d29f9bd5ca66806471b17e8941206e985f6bd8817a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7d6c3c3efa789c2087087ce41658a08cb659273ac61dc5c8df05fa3a8bf6b7"
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
