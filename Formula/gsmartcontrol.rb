class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.0.1/gsmartcontrol-1.0.1.tar.bz2"
  sha256 "4ec0320c4c40a129cacabbfa7f302146abb69e927cfe9ded0e55b5b9cbe0d949"

  bottle do
    sha256 "9a2ab668312cec8878dbd951a5af49a881e187d1ecc632ec6ee00d4626981acd" => :sierra
    sha256 "5bb11b94b55b467f318f431a808389bbbf6a6d1e4aa49e5975e749b038067529" => :el_capitan
    sha256 "4002da9110c0213b2d77a1e8b93097a925784b8d467371eb120b3a320d2ac669" => :yosemite
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
