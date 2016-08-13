class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.32.2.tar.gz"
  sha256 "8a578b9022b90a9585471fbaad991148a336215008b42b497463bc91bde9fcf7"

  bottle do
    cellar :any
    sha256 "d45a25ffd70e67c28c4207820ded141077fe23a0a5fec78264484f4567b92c07" => :el_capitan
    sha256 "da0aac4ef7653e8ec640c061abb414c7f4a610da4bb38a904f4df81a1a27bf05" => :yosemite
    sha256 "fdaa5b72b603483ece6df3a4065d3bbc1874bee7329c3a1f0ae47bcd6a550724" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "poppler"
  depends_on "boost"
  depends_on "leptonica"
  depends_on "openssl"
  depends_on "rapidjson"

  def install
    ENV.cxx11

    system "autoreconf", "-i"
    system "./configure", "--with-openssl=#{Formula["openssl"].opt_prefix}", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pdftoedn", "-o", "test.edn", test_fixtures("test.pdf")
  end
end
