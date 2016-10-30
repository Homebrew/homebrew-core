class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.1.tar.gz"
  sha256 "d00ed04a4f58cc1163cc581cf738e53d872ea59f9e5f94fa9cc61ef59b8d9c13"
  revision 2

  bottle do
    cellar :any
    sha256 "3185a2199a3bb4e96b5d722ce584c3d35698fe920a1e5d190b5db82d338dece2" => :sierra
    sha256 "eacb1b8cd8ac9765cad1b585b2e7c5d075dc7d27797df526782600d0e8e16833" => :el_capitan
    sha256 "ac0d11e20d0de0df76ad4a2d3cf27e33847d6beb95d6c656fe0c7f64ebb94882" => :yosemite
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
