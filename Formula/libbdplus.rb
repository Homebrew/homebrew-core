class Libbdplus < Formula
  desc "Implements the BD+ System Specifications"
  homepage "https://www.videolan.org/developers/libbdplus.html"
  url "https://download.videolan.org/pub/videolan/libbdplus/0.1.2/libbdplus-0.1.2.tar.bz2"
  mirror "http://videolan-nyc.defaultroute.com/libbdplus/0.1.2/libbdplus-0.1.2.tar.bz2"
  sha256 "a631cae3cd34bf054db040b64edbfc8430936e762eb433b1789358ac3d3dc80a"

  head do
    url "https://git.videolan.org/git/libbdplus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
  end
end
