class Es < Formula
  desc "Extensible shell with first class functions, lexical scoping, and more"
  homepage "https://wryun.github.io/es-shell/"
  url "https://github.com/wryun/es-shell/releases/download/v0.9.1/es-0.9.1.tar.gz"
  sha256 "b0b41fce99b122a173a06b899a4d92e5bd3cc48b227b2736159f596a58fff4ba"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "53f0c0654ddecc62b99135fb96722b6467593248d884c1506ea93681367c611d" => :el_capitan
    sha256 "bceadf8a0ef4d3231d149f30cc53d2c7fe686cd8fdd0dafe83ceaabc35151d5e" => :yosemite
    sha256 "14f203383d01f581bdb63e7240ff57d1174553467314351d49ea41d3052148f9" => :mavericks
  end

  option "with-readline", "Use readline instead of libedit"

  depends_on "readline" => :optional

  conflicts_with "kes", :because => "both install 'es' binary"

  def install
    args = %W[--prefix=#{prefix}]

    if build.with? "readline"
      args << "--with-readline"
    else
      args << "--with-editline"
    end

    system "./configure", *args
    system "make"

    man1.install "doc/es.1"
    bin.install "es"
    doc.install %w[CHANGES README trip.es examples]
  end

  test do
    system "#{bin}/es < #{doc}/trip.es"
  end
end
