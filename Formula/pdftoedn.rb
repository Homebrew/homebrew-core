class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.35.2.tar.gz"
  sha256 "a18bbca8011e4e6c04c97f0a58c588047d88a2a1fcf1710eeb7a8a0a9b181517"
  revision 1

  bottle do
    cellar :any
    sha256 "191b70b1a420ee93aba92688cdab7e3421b8b848b66490b244f6823783091984" => :high_sierra
    sha256 "3787658cee0707c949d5b0eadaf44951ce4e4dacb63f46db58b2049fa9769ea6" => :sierra
    sha256 "53593a56c313b7fd292100062d8f2513a8d52a868e4f93422645c95ee681d63f" => :el_capitan
  end

  needs :cxx11
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
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
