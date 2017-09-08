class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.3.tar.gz"
  sha256 "7ff6d097d1a53246b3c71d9fdaeb58e43aac14291f647d76855c62769c585f25"
  revision 3

  bottle do
    cellar :any
    sha256 "929087813e0b273c62b64ec158aff3987e6dcc2cdf6971cdd43be99e201a25a1" => :sierra
    sha256 "743dbf0b397d21e1b98ab4ba7d418f801074ab129bb846949e4b7171962ac899" => :el_capitan
    sha256 "865e87ac472296eefaee72426896ee91f4e474329d24476977a0b31548f69dc0" => :yosemite
  end

  needs :cxx11
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
