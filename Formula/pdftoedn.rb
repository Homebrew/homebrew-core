class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.5.tar.gz"
  sha256 "ddb99ee556ff6c59c606f46142be94f59e03914efddc4ce5cdf3274fa86dc826"

  bottle do
    cellar :any
    sha256 "75588ab3755054d90bb1b45b4115815c3fdfb68a0ad842e7fdc24a5799c13e7e" => :mojave
    sha256 "dd6b30fd1194f80a7e8d47096039d690678e2dcf5082a6b67dc721f97b9b5e63" => :high_sierra
    sha256 "00a85b3300106938ab8b60d0002b292e7372102ae0b58188c8186d8b5e01ed69" => :sierra
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
