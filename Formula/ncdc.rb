class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.22.tar.gz"
  sha256 "fd41ef85cec3eca0107d83583ad25faa8804dd22d76f6da7fc157e0233b13a59"
  revision 1

  bottle do
    cellar :any
    sha256 "bd458109141b6ba53b1cfb1f7a6c23f54b9f9a394aa343ea45b5c266ddcc6050" => :mojave
    sha256 "8674135fbed6f357731b7c758ee1b57ef4e37f5d939ec0033cf20c7b2df5062f" => :high_sierra
    sha256 "fe29149237f3e024935eaca35954a829b21983871ee2976029f7fdc92ef2b491" => :sierra
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
