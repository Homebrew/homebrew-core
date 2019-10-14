class Es < Formula
  desc "Extensible shell with first class functions, lexical scoping, and more"
  homepage "https://wryun.github.io/es-shell/"
  url "https://github.com/wryun/es-shell/releases/download/v0.9.1/es-0.9.1.tar.gz"
  sha256 "b0b41fce99b122a173a06b899a4d92e5bd3cc48b227b2736159f596a58fff4ba"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "034c7d219310fe7a27dd50d3c7d628419d0176d09e0d6cb9e863eb185d544824" => :catalina
    sha256 "0b6411663827c69bb38ca5973201e66d293eaaece30d93cd4b62db6449d62756" => :mojave
    sha256 "b8fdbd8dd642283af492c5f6c72d23b39cc9819f543908c0d3d3c2c71d86151d" => :high_sierra
    sha256 "7fa9e3a21662d59d5505fda8945435f71331647d6efdae0ce7112bd507af3398" => :sierra
    sha256 "53f0c0654ddecc62b99135fb96722b6467593248d884c1506ea93681367c611d" => :el_capitan
    sha256 "bceadf8a0ef4d3231d149f30cc53d2c7fe686cd8fdd0dafe83ceaabc35151d5e" => :yosemite
    sha256 "14f203383d01f581bdb63e7240ff57d1174553467314351d49ea41d3052148f9" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-editline"
    system "make"

    bin.install "es"
    doc.install %w[CHANGES README trip.es examples]
    man1.install "doc/es.1"
  end

  test do
    system "#{bin}/es < #{doc}/trip.es"
  end
end
