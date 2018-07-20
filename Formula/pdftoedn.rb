class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.35.2.tar.gz"
  sha256 "a18bbca8011e4e6c04c97f0a58c588047d88a2a1fcf1710eeb7a8a0a9b181517"
  revision 1

  bottle do
    cellar :any
    sha256 "a6b50f9eaa612dd9a66802c76bfe5ace4973a154d51b2e89494fae504c5deeb3" => :high_sierra
    sha256 "a09b1822ec9325613a30ce3d545f8d0f3905f3b5a5939d67a7b1449085290953" => :sierra
    sha256 "5b3409aac93ec91b58cd3e443cd6d20e6466398e7b7cbe01463a8fc152684b83" => :el_capitan
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
