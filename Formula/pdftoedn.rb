class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.0.tar.gz"
  sha256 "3a397b7ee9dbc26b29dbd16dc48c1704006bf10be6138c54529ea1df1810df86"

  bottle do
    cellar :any
    sha256 "8ff97d5bf82e9984346382c2cc0c4819760a78b5016f593f117250a9cac31a81" => :mojave
    sha256 "dea27c1913659e659aa46c681941a682c356d06986763ceb93a1104238fc6751" => :high_sierra
    sha256 "1c337599a1b1a0cf3ca3928aee67e9dff71fd4fe35b6085f55967708f9dcb5e5" => :sierra
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

  needs :cxx11

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
