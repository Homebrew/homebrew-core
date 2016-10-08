class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.1.tar.gz"
  sha256 "d00ed04a4f58cc1163cc581cf738e53d872ea59f9e5f94fa9cc61ef59b8d9c13"
  revision 2

  bottle do
    cellar :any
    sha256 "3867cf77c2226770eab4014aea7ae39ae89a3cdb02d81b918022557aca37b8a5" => :sierra
    sha256 "cd0199695e2cd739c86b3d03eeaefb1564b37b671b1d53733ba6963dc5082bad" => :el_capitan
    sha256 "7e62b90c53555db9913a33f29fe58875b83e56e7c5b5009cfe88dcc618834230" => :yosemite
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
