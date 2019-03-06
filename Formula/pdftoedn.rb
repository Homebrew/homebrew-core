class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.7.tar.gz"
  sha256 "6e3d54d2bd39184c37167783805558c4ebf37dbc6e5acbe9d516bd5a4d1b37dc"

  bottle do
    cellar :any
    sha256 "f442e7e0aa80a3fe4596811a7a6438abed218120ae9adfbe10a35a7f91d055e5" => :mojave
    sha256 "76f83f7bd6a3a0a91bb636099e66f66fe65fe44affb8cfe977d7b1ede8c13460" => :high_sierra
    sha256 "ddfee880389e013ef41f8fe338cfc95c7909e1a25326c7abf4d45704c7cd07fb" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "leptonica"
  depends_on "libpng"
  depends_on "openssl"
  depends_on "poppler"
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
