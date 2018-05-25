class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.35.1.tar.gz"
  sha256 "566b9ed81a60aa2579da60e2ae0f7d73292a1f7ba41280e392c0d4b1297e49b9"
  revision 1

  bottle do
    cellar :any
    sha256 "1ba3d283f69c6649fe0d469c33609c96a47fee6084e4310e958c191332bd226c" => :high_sierra
    sha256 "a2886243617ac07f1143b4b67a8328e490d979b3849cd42cbbd757aa6cd2431d" => :sierra
    sha256 "0234ec5ddeb16a072206b3a4b56012942d851c03ef3cbc5d94e905d669ea5f5f" => :el_capitan
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
