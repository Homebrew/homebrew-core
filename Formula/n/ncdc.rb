class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.24.tar.gz"
  sha256 "233510d5355fc72fdad3578ebc8ab35d1da95b21d2774990f3a1356b7112da1e"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ncdc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "448965a91bec01318b95c036154514b67d5fd6efffe221c0272df7a3c49335db"
    sha256 cellar: :any,                 arm64_ventura:  "bea97fd261d2f4f4d84459837a6859e68bdac8e9de67d1c62bbdc00b13eebb86"
    sha256 cellar: :any,                 arm64_monterey: "6e025f32af0b6590e8025c6bfe8376849e94e8024a2343180dc48bae6a5ed187"
    sha256 cellar: :any,                 sonoma:         "e41987d8e45d9117aa0718bdf2d612cf6eaac9437a7849599f82635af84fa498"
    sha256 cellar: :any,                 ventura:        "b981d0d4ffac3f1654aecdc787639222885378a3f7edb5532f68bd7d455898ce"
    sha256 cellar: :any,                 monterey:       "cfeff0459c43337224add6446e25c485696ba681e4ae8ac5fcdf0bf57c359ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d830ea52e8f48bb16592d0513ede1f09a91bac6e5971decdb942c64095aec9bd"
  end

  head do
    url "https://g.blicky.net/ncdc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "ncurses"
  depends_on "sqlite"

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ncdc", "-v"
  end
end
