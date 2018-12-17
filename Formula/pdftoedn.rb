class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.3.tar.gz"
  sha256 "89d8cd10e960841083a4a1ab7b2266a741b47763b76818e272f7b81016e4eabb"

  bottle do
    cellar :any
    sha256 "3da465d632d051a1fc511bb0e446751b6881fac5f2e5e8458252c1967c727046" => :mojave
    sha256 "7e69803973e82f9083f6bfc97c52190287d8f5a878c8290cb0e8635f56c76840" => :high_sierra
    sha256 "5737d13d9453c45839dd8c331c85d8b399a99aec3ce2b999d01157c71a693583" => :sierra
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
