class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.35.2.tar.gz"
  sha256 "a18bbca8011e4e6c04c97f0a58c588047d88a2a1fcf1710eeb7a8a0a9b181517"
  revision 2

  bottle do
    cellar :any
    sha256 "ea0fd5ee6368dcb12554ef549c6f5c68e4ea92a2e8272eaf350bf023f5690b65" => :mojave
    sha256 "dc9f6d75e1aeb5465baeb41d864cfe1b0a45133d5c5224b50becff40d4207a2c" => :high_sierra
    sha256 "39e1fd4083e7d19ae217b1dbe5402e49f453588f58d494df9c2ddc1839c74688" => :sierra
    sha256 "5a8222824bb091c375e44d689095fac4626966b8b8241875ffd112a5e020f8c2" => :el_capitan
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
