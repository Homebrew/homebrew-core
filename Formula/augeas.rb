class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.7.0.tar.gz"
  sha256 "b9315575d07f7ba28ca2f9f60b4987dfe77b5970c98b59dc6ca7873fc4979763"
  revision 1

  bottle do
    sha256 "5aea6d7dacc6810656d1818aaf7ef9a57bd086dad1ec2e2ad57a3c37b35438a5" => :sierra
    sha256 "09deb1d25802e17034606b4fdd2509e59b50b25c4ff481a73ee5509770c9e265" => :el_capitan
    sha256 "fe5a04d2e9d02a1bdc013e4db6bd3047e9c7e12b2ab400cdb21f34b9d0a1ff63" => :yosemite
  end

  head do
    url "https://github.com/hercules-team/augeas.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "bison" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Lenses have been installed to:
      #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end

  test do
    system bin/"augtool", "print", etc
  end
end
