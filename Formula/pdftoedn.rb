class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.35.1.tar.gz"
  sha256 "566b9ed81a60aa2579da60e2ae0f7d73292a1f7ba41280e392c0d4b1297e49b9"
  revision 2

  bottle do
    cellar :any
    sha256 "31ba044213a88d3c78b27f1812d9f0c73586c1a16f97c51e3d5a248e7a1d60c7" => :high_sierra
    sha256 "e4ea7163c28f5278846488c106fee6eef9d9525991ba4f4e13358029ef2be318" => :sierra
    sha256 "af16e4ce1bdda1c3811f5a2347392f7331b7c78b03677960683a414814be07a0" => :el_capitan
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
