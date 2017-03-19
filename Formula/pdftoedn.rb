class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.1.tar.gz"
  sha256 "d00ed04a4f58cc1163cc581cf738e53d872ea59f9e5f94fa9cc61ef59b8d9c13"
  revision 8

  bottle do
    cellar :any
    sha256 "baf5e64e9ac5e8cf136ebd81076da02d6ee026befac74e6096f74233533b660a" => :sierra
    sha256 "9c94bf23ddd3c68ce0b439c0051681f310d938ae96a51e88e14bea90500f70da" => :el_capitan
    sha256 "8c79bb5a6e3f1d6c010f4475d8d529e50c9d9d6dd24931a3ab5f39da24db1abd" => :yosemite
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
