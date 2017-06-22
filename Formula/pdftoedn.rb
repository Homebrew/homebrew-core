class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.2.tar.gz"
  sha256 "94e5888accae92380fd5e4b6a7ee4211f05814059a9f540b071a27993113be95"

  bottle do
    cellar :any
    sha256 "db8f9c057ef6d61f212af758657761c145be9e907243c335a71c873f9b1fa237" => :sierra
    sha256 "7832214135fb38d8154d48b9f4f1ff7776b3c2a34732a394bfd04c385d162367" => :el_capitan
    sha256 "fcbbfdfc4b2e91e4daba9712bf04b7ceeb946f1db00adab7003b91945b6e0e54" => :yosemite
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
