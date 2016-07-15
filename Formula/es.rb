class Es < Formula
  desc "Extensible shell with first class functions, lexical scoping, and more"
  homepage "https://wryun.github.io/es-shell/"
  url "https://github.com/wryun/es-shell/releases/download/v0.9.1/es-0.9.1.tar.gz"
  sha256 "b0b41fce99b122a173a06b899a4d92e5bd3cc48b227b2736159f596a58fff4ba"

  bottle do
    cellar :any
    sha256 "913ca2237f6dee8fda5024158cf74d6c531fa5f1d5543e48bd88a0b0c00043f0" => :el_capitan
    sha256 "b030162c4cf054e3c5faaf4184634f438734ef5d44d0fa0b26e21da53cfe3b97" => :yosemite
    sha256 "dc05ff3d6cda43cd0c8a0423eeefaf8a517d6a5412b561b7092451c4d49e1adf" => :mavericks
  end

  option "with-readline", "Use readline instead of libedit"

  depends_on "readline" => :optional
  depends_on "readline" => :linked

  conflicts_with "kes", :because => "both install 'es' binary"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-readline" if build.with? "readline"
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
