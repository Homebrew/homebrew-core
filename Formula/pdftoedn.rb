class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.35.1.tar.gz"
  sha256 "566b9ed81a60aa2579da60e2ae0f7d73292a1f7ba41280e392c0d4b1297e49b9"

  bottle do
    cellar :any
    sha256 "0bf3c092da3990f5146527c6a03dcb3b6d3553c9998243dc772b2cb54fd20f57" => :high_sierra
    sha256 "b3a8b039dfa9b29743e892570508495d374d1ad80780c4d08cceb692661c9f4d" => :sierra
    sha256 "2d6408b2497d22ad471ace3e4f2286a591e80477dbd2872a8ed0d6ab78492dc2" => :el_capitan
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
