class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.11.0.tar.gz"
  sha256 "393ce8f4055af89cd4c20bf903eacbbd909cf427891f41b56dc2ba66243ea0b0"

  bottle do
    sha256 "cebc1b3db31952c0d347586576b983a7f0585f0791e6ed9cab40bbd7485eeca8" => :mojave
    sha256 "589af77e50225882c0f052379ffdcf935bba550f01190074395f6b5e195cb332" => :high_sierra
    sha256 "1fbc0ab4f4537d59730fc84829cac47eb98362178423fed6f3e3241ec0c306d2" => :sierra
    sha256 "afd1ca94038dfcccb49b2d5c36ebbc45ca95d749d847a25e26c39c080edf5f64" => :el_capitan
  end

  head do
    url "https://github.com/hercules-team/augeas.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
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

  def caveats; <<~EOS
    Lenses have been installed to:
      #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
  EOS
  end

  test do
    system bin/"augtool", "print", etc
  end
end
