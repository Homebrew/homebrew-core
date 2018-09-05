class Pgdbf < Formula
  desc "Converter of XBase/FoxPro tables to PostgreSQL"
  homepage "https://github.com/kstrauser/pgdbf"
  url "https://downloads.sourceforge.net/project/pgdbf/pgdbf/0.6.2/pgdbf-0.6.2.tar.xz"
  sha256 "e46f75e9ac5f500bd12c4542b215ea09f4ebee638d41dcfd642be8e9769aa324"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a76ca05c6b73ea6fcf57d6699cbaf3e249c5e3b20990e51ab33d11bfbdd7d50" => :mojave
    sha256 "caf544eee09339bb34ab68a35880bc863bb13aa7943de98ef25680cb0182f901" => :high_sierra
    sha256 "7d0eabf3051e9cf450d985987f89cf0d70476b37202b3b5bdc84ec48e8cb670d" => :sierra
    sha256 "72ad6b801d25db2008d0ab4badd2bb280f55eb6f6956925ee5620d62d8f06bbb" => :el_capitan
    sha256 "4042a284cac8abe88e7d1c9e6c003e00a9b8247905739829cd768a824df7993b" => :yosemite
    sha256 "c53298c57bb2d31d82ddce41ed65057d7781de2118857f5f795aaaefe3c00110" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
