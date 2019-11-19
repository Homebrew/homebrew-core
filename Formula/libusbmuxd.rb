class Libusbmuxd < Formula
  desc "USB multiplexor library for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  revision 1

  stable do
    url "https://github.com/libimobiledevice/libusbmuxd/archive/2.0.0.tar.gz"
    sha256 "ecf287b9d5fa28645a6b5ed640b6bd174134227c4fd8fde28d0678df2be0e97a"
  end

  bottle do
    cellar :any
    sha256 "da715ab9973ef748f7edec181f6e4d694a9d36d14bcca279f3734eb307c7782e" => :catalina
    sha256 "d96ad61ee9e0a3eb547cc80a2423fafa43397f627012a7ea5e9c3ed3b6fe8a3a" => :mojave
    sha256 "f388c09dd9a8a8d86cba0eff7af3426cb6ffeff127182ba8aabd91a290565873" => :high_sierra
  end

  head do
    url "https://github.com/libimobiledevice/libusbmuxd.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libusb"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iproxy"
  end
end
