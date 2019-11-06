class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.22.1.tar.gz"
  sha256 "d15fd378aa345f423e59a38691c668f69b516cd4b8afbbcdc446007740c3afad"

  bottle do
    cellar :any
    sha256 "2f074f7eb6aa1a1d0024e1f900315cb4bd056ad711c0f504acb160714e07597a" => :catalina
    sha256 "4490571bb2101e00e3edc39ab25baf75a63dfd9617381ae0f102a274a2fbf622" => :mojave
    sha256 "bd143dd032839762597253796c562607e43c654c128d4f4162fd382fd660dbfd" => :high_sierra
    sha256 "59f5011b9c39b78c75a2bf5d93ae398a16660852a3b8fd8ed3a3389ea463fbf7" => :sierra
  end

  head do
    url "https://g.blicky.net/ncdc.git", :shallow => false

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
