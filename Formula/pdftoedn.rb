class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.4.tar.gz"
  sha256 "4714f2525a41574ad8601b5d68d82975615a52475088fa9f02e83ecb7a68b363"
  revision 1

  bottle do
    cellar :any
    sha256 "5d18028fb153c2e7d5bc9e9b85b28dd17409a68fdb000b0d11c71cec6a895dba" => :mojave
    sha256 "232429ac01663673c3b6fa7c0baf175fa424e29baf9239ed3188ed4bb441c14d" => :high_sierra
    sha256 "9457c29282718ef5706f13399c5a43e0855d101195afb2c4bb4c875f22a21244" => :sierra
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
