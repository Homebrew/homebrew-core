class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.22.tar.gz"
  sha256 "fd41ef85cec3eca0107d83583ad25faa8804dd22d76f6da7fc157e0233b13a59"

  bottle do
    cellar :any
    sha256 "40367ef4c655446b525a7f658e301ec98e91196b4bc96a66c5bbda289e4cd424" => :mojave
    sha256 "6d5f7db3e2ac217f0c5d69e55f4d7137c953266a1c866632ffb6645b4a2f636d" => :high_sierra
    sha256 "61508189d955b4a4605fd63384af4f6a6feff719473a0f384015f23e7a3e66b1" => :sierra
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
