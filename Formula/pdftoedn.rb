class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.1.tar.gz"
  sha256 "d00ed04a4f58cc1163cc581cf738e53d872ea59f9e5f94fa9cc61ef59b8d9c13"
  revision 3

  bottle do
    cellar :any
    sha256 "e015ea561632ee794ecb3adfa164db168fd1fe93e82abc459f5d5d43a0d6ad21" => :sierra
    sha256 "b4b52f9ccdad732041a65792d3cca89b8a872c5063bf60f2778a872c3678d9a3" => :el_capitan
    sha256 "74cb780d4af1bcb00315c47b1eea6418dc124f5edd5a4c3a14f6b74c0ce72c9e" => :yosemite
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
