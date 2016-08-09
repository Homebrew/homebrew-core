class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.32.1.tar.gz"
  sha256 "7b56e404710c0d835e8b693660a6e4e98e2d37ab7329a4f67010a10c34235e85"

  bottle do
    cellar :any
    sha256 "6c883c477b9b540149d9ca1a31eeab682b0242b7afea3a9bd3485179f0bed36b" => :el_capitan
    sha256 "5e23af8e3fddab3cedb5374079180f4f4c071eed3ab3a1e51c094ec8dc6d6550" => :yosemite
    sha256 "588045d35a61f45c5669b7af583f463c212e408676bbe286ca8922aeeb65d8cf" => :mavericks
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
