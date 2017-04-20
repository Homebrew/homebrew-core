class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.1.tar.gz"
  sha256 "d00ed04a4f58cc1163cc581cf738e53d872ea59f9e5f94fa9cc61ef59b8d9c13"
  revision 8

  bottle do
    cellar :any
    sha256 "b9f81e2aa6c98f535e7589a08b57e42b1cd07db69fd1cd29c4dae4e96348e0b2" => :sierra
    sha256 "dd010f0ad6723ca3b0c24dc46ed2a8ffde02d3bc9c86f5a7b1ad4d5e7381380b" => :el_capitan
    sha256 "4547bd0f3d2150c18ba61be168fb8378583e6817fba6fdbc8cebebc23d58b7d0" => :yosemite
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
