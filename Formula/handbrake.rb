class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.2.0/HandBrake-1.2.0-source.tar.bz2"
  sha256 "113b398a50147d48c8777e6ff2c4de6825af5f1079b3822e41bf0eacec9c940d"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    sha256 "ec78b6794e70d906a4814ad3622ae2ee4d8d65961ec0c70b979dd316303b043a" => :mojave
    sha256 "2e3ddd3d1b7a0df8b0ef9f2cab5f51f9994008c3a543578a6795db3d1ffd4f89" => :high_sierra
    sha256 "97484268f8fc9f9996634f916d72a7b348c6dba83b37beb1a032f3b614b1cd3e" => :sierra
    sha256 "8c758733f241bf05a42ce06ad752bbba16b36ef520a0b9df239539af9863c356" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "yasm" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
