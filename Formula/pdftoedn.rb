class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.2.tar.gz"
  sha256 "94e5888accae92380fd5e4b6a7ee4211f05814059a9f540b071a27993113be95"

  bottle do
    cellar :any
    sha256 "9fbd1363d006cca21c43249e6abdbbedcebef1f6c68e03fb5f6b85bd0f16d388" => :sierra
    sha256 "e32e84d0640ba96e85e060eed1da7d0d368e87498fcbd43136b71901fb01f7f9" => :el_capitan
    sha256 "269e480cefbe479d213d440ba0e90457290da4710d1a1dcfa390f15917a832de" => :yosemite
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
