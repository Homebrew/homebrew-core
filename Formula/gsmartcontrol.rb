class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.0.1/gsmartcontrol-1.0.1.tar.bz2"
  sha256 "4ec0320c4c40a129cacabbfa7f302146abb69e927cfe9ded0e55b5b9cbe0d949"

  bottle do
    sha256 "74418f9a4fd88bb957d1c10725ffc509b9955075646b7ac0b18d9ef3c65730b4" => :sierra
    sha256 "1d5d9c1007c083f8806a6243eca3907c16986d667bdca947379d95de409a4b2c" => :el_capitan
    sha256 "adf4259a04f10319300f83ffe55f309271490763af48dc8a02ab05cc1009b00f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "smartmontools"
  depends_on "gtkmm3"
  depends_on "pcre"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gsmartcontrol", "--version"
  end
end
