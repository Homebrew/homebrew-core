class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.7.tar.gz"
  sha256 "6e3d54d2bd39184c37167783805558c4ebf37dbc6e5acbe9d516bd5a4d1b37dc"
  revision 1

  bottle do
    cellar :any
    sha256 "e4580324d23d19a3f7f8e5b2f3d9903939c31f258bf663418875786e9ab60aec" => :mojave
    sha256 "5cf85ec705f7bf3ca8b6b91ca166821e5e23f080bd89e6e104720f9be7c59d7a" => :high_sierra
    sha256 "6dfca731a6beaa81ce629a205e8428d11afd1c468c6e0bc1056e2ffa32e5a57f" => :sierra
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
