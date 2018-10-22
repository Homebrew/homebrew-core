class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.0.tar.gz"
  sha256 "3a397b7ee9dbc26b29dbd16dc48c1704006bf10be6138c54529ea1df1810df86"

  bottle do
    cellar :any
    sha256 "4828137880e76a5d0adfa081b89c159cd05412f5d4fa1bde65334d5bf5dfc052" => :mojave
    sha256 "7dda77e8458056cf17b29e9cd712f2ca95c2b43eda09584071956c637d9e3a51" => :high_sierra
    sha256 "3a045036e9e69bc4811dcb9cff8b36ac5574c54a23ca2c10eeb079a8effe8a5f" => :sierra
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
