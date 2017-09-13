class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.8.1.tar.gz"
  sha256 "65cf75b5a573fee2a5c6c6e3c95cad05f0101e70d3f9db10d53f6cc5b11bc9f9"

  bottle do
    sha256 "75364cc05fc1339420009ec4cd3e790a22859cdb0333e796c45069bf79ae26b6" => :sierra
    sha256 "3cd952d2bfb3fe7a320e5529df05d21c1e359aa83e7d0ed8dac6b78a724ed986" => :el_capitan
    sha256 "dc930d22881a18afe246b0bf18fc449bfd900de9f562b21f6b35b217470d0862" => :yosemite
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
