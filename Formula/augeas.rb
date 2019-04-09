class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.11.0.tar.gz"
  sha256 "393ce8f4055af89cd4c20bf903eacbbd909cf427891f41b56dc2ba66243ea0b0"
  revision 1

  bottle do
    sha256 "7069fa64198cacc1df2240840e214e3071ef09298feb5f8d4f215ff7eb6751a0" => :mojave
    sha256 "e5c5c1548077ab50027b0079bec99b9bd7ad75c872b4e0d6d9a3f431af500765" => :high_sierra
    sha256 "1be7a367767198aedebd736f14ce80b9314d7dc216575d678b9a32a905fd5b79" => :sierra
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
