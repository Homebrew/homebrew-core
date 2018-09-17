class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.35.3.tar.gz"
  sha256 "b73c0f95b79882dad639828629c9e66455899edb5d601d4f1daef78844dacebf"

  bottle do
    cellar :any
    sha256 "244e254498ca8effe544f34c59b9736a5af30fde2d4919b71640e991ed07dfb0" => :mojave
    sha256 "f7447fa849fc719c63d60af5c4a943a6a5c1652c628eb84210ea4878561be7ab" => :high_sierra
    sha256 "6fc656b3cfab4baa234bf448df039d3b1d04adf2b00494d58f6125170c0bd66d" => :sierra
    sha256 "6c183e93d3579a69b5bc3092bee87059b93581fd34c95a92d164977aeb0708af" => :el_capitan
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
