class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.1.tar.gz"
  sha256 "14e6df5df9a24225fcb9a92669899c2ab9ccb3742a2738300fc393b8b95416c4"
  revision 1

  bottle do
    cellar :any
    sha256 "d2555c6523532ad0ea177a20b4a84abca5f336fae4dcf7ee631ba25a6284bd1e" => :mojave
    sha256 "bb5bfd1f9eb72c085a516a9155dac320d45b0584709cc9985bf4fdc9c7833be1" => :high_sierra
    sha256 "f9c45af7767fcdffe0e32960a47e8e1f9befdaed2cb3013427460eae9c247833" => :sierra
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
