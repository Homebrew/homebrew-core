class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.7.0.tar.gz"
  sha256 "b9315575d07f7ba28ca2f9f60b4987dfe77b5970c98b59dc6ca7873fc4979763"

  bottle do
    sha256 "25d35a088046e227f3ad7757b23a7c1c245bbc60626b1da63f4435fb85a6669f" => :sierra
    sha256 "7500d3d74c5dc96fdaad93b80fd2f31558cd7ad266ba5d7c194212851760830f" => :el_capitan
    sha256 "fb10a29e31b580bc469b593cc79e364ef2340e30118e0d49da15812a7b7dda4a" => :yosemite
  end

  head do
    url "https://github.com/hercules-team/augeas.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "bison" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2"
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
