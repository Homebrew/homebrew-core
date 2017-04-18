class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.8.0.tar.gz"
  sha256 "515ce904138d99ff51d45ba7ed0d809bdee6c42d3bc538c8c820e010392d4cc5"

  bottle do
    sha256 "15994a8faab3ffce25247d555c27a88c7e3be9dc44c6e9543a9c347c3c77a60f" => :sierra
    sha256 "a5a85a19c1ddf5e649d60d0d1f473aae3360f1ae42959f5e384ff5a90d20bc55" => :el_capitan
    sha256 "c3144c07fa149b7909954e751ebe57031371bfe6961cbf509e2d8cb3110e7ba9" => :yosemite
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
