class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.3.tar.gz"
  sha256 "7ff6d097d1a53246b3c71d9fdaeb58e43aac14291f647d76855c62769c585f25"
  revision 5

  bottle do
    cellar :any
    sha256 "8416d2882ad23ad9099998db76750473204dda06fba89b9fa36a2c7e2261397b" => :high_sierra
    sha256 "47a6f92013715c377f9db7816b7496e1dd1f976d2ba441637b59a7061c950324" => :sierra
    sha256 "08d42fc437f5e7a0f953d5f2653b7c31d0c72a4929f58b9748c7ad0956cd8353" => :el_capitan
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
