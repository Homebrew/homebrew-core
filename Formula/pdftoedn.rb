class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.1.tar.gz"
  sha256 "d00ed04a4f58cc1163cc581cf738e53d872ea59f9e5f94fa9cc61ef59b8d9c13"
  revision 5

  bottle do
    cellar :any
    sha256 "ec375444ab6890c5df66c98b719bff07c0638863eddf0637603a5dc3a1c4a135" => :sierra
    sha256 "ba2838223989a244dd918d036c11e3a7709dd40e536fa4f897b094503305eb1b" => :el_capitan
    sha256 "619e26f2ba972917d3f4ba64157cbd2266e7349baa952ec2c098ad9f37ea007f" => :yosemite
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
