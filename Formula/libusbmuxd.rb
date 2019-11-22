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
    sha256 "cd86a52e7d94295f6ddb4f61449f349f22e6ebe0dec876904a0bdde78869035b" => :catalina
    sha256 "c296286ac58e0afbd167f37b7be5ced50c104252d69878e9a54f33268eb54a54" => :mojave
    sha256 "c37185be694168115ef33c17794a3a00ef3e917ade673f0a6a7f39fb3a9dd5dd" => :high_sierra
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
