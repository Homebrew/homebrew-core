class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.1.tar.gz"
  sha256 "d00ed04a4f58cc1163cc581cf738e53d872ea59f9e5f94fa9cc61ef59b8d9c13"
  revision 9

  bottle do
    cellar :any
    sha256 "1bbb8699552baeefd7a0a95ea391f207bd8205689f7bc534ea5a7185906fe16e" => :sierra
    sha256 "b591a4f0d08cdfebab6a56eb2785e031e839c5197b87ef0ddc167886443dd391" => :el_capitan
    sha256 "dcf573dc87b6e8de41c8c67d40ee42e5e3af0a94280df20ecd84b97e84f0ec50" => :yosemite
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
