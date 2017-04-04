class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.7.0.tar.gz"
  sha256 "b9315575d07f7ba28ca2f9f60b4987dfe77b5970c98b59dc6ca7873fc4979763"
  revision 1

  bottle do
    sha256 "1c716bb7d86b09efd199313bf5b6a96dc2cc26daa396dac53306495f4264820a" => :sierra
    sha256 "5e1e3b68d2468e67f0728c1fb5dc980343ce8ac35276b83c42761b37907d75fe" => :el_capitan
    sha256 "f535bf25d2f96873065c3001813c219c135fae7c4db249c21300bcec4c701b4d" => :yosemite
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
