class Ideviceinstaller < Formula
  desc "Tool for managing apps on iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://www.libimobiledevice.org/downloads/ideviceinstaller-1.1.0.tar.bz2"
  sha256 "0821b8d3ca6153d9bf82ceba2706f7bd0e3f07b90a138d79c2448e42362e2f53"
  revision 4

  bottle do
    cellar :any
    rebuild 1
    sha256 "3fcfe52042361034d6d884268c6e145db6ccae21a65d55fae590b8d3203209e6" => :catalina
    sha256 "e0df189964f8d77e2ea30e8255b7d5a6fa82710b9b65e1351f086358530f6d84" => :mojave
    sha256 "d8f6c9528b2737db5453b118e8792533274df7b06968c868ba0096cf62e48079" => :high_sierra
  end

  head do
    url "https://git.sukimashita.com/ideviceinstaller.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libzip"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ideviceinstaller --help |grep -q ^Usage"
  end
end
