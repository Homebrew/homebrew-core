class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.22.1.tar.gz"
  sha256 "d15fd378aa345f423e59a38691c668f69b516cd4b8afbbcdc446007740c3afad"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3851c0505db606f727353c388b30563b23001ea02e9190216495f7e6df1ce03d"
    sha256 cellar: :any,                 arm64_big_sur:  "7dfeff7bcbd463dd11bcc08b52114a445cacfae8ca7f0f6c8fae65c9e4b19d4a"
    sha256 cellar: :any,                 monterey:       "1eaf5107e1f62d171a4468bf01356120a033fbc5fa82f21666786c5a255c0159"
    sha256 cellar: :any,                 big_sur:        "f0ea06824da1588311108a37cd60eb32692383a062c0d59f7c366f870692ca1f"
    sha256 cellar: :any,                 catalina:       "2f074f7eb6aa1a1d0024e1f900315cb4bd056ad711c0f504acb160714e07597a"
    sha256 cellar: :any,                 mojave:         "4490571bb2101e00e3edc39ab25baf75a63dfd9617381ae0f102a274a2fbf622"
    sha256 cellar: :any,                 high_sierra:    "bd143dd032839762597253796c562607e43c654c128d4f4162fd382fd660dbfd"
    sha256 cellar: :any,                 sierra:         "59f5011b9c39b78c75a2bf5d93ae398a16660852a3b8fd8ed3a3389ea463fbf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e49b825062b7702a59fff600e5d623d252ea6bb1833707c51290abcf68e5290"
  end

  head do
    url "https://g.blicky.net/ncdc.git"

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
