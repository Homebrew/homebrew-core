class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.1.tar.gz"
  sha256 "d00ed04a4f58cc1163cc581cf738e53d872ea59f9e5f94fa9cc61ef59b8d9c13"

  bottle do
    cellar :any
    sha256 "04741c63be592ede3c058ede03b215491524f4b8610c201ccae25fe4ffa18367" => :sierra
    sha256 "1db4ccab956227cf5db09e9a925b0373427e3d237e4486661e13d2b1b4bcde1f" => :el_capitan
    sha256 "3e0307c2943aba4c8dc1d849c579f75bcca989b24f1470b8da25817c03b27d50" => :yosemite
    sha256 "08959d8bb3f153e9ab5dd34827387fcea19c167f3ac1dbc5566eb35b638d5a5e" => :mavericks
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
