class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.1.tar.gz"
  sha256 "14e6df5df9a24225fcb9a92669899c2ab9ccb3742a2738300fc393b8b95416c4"

  bottle do
    cellar :any
    sha256 "b861bc1547fa89aae47466cfa22d8487ab705b45575eb92bd1c7ec3d772e71af" => :mojave
    sha256 "9ad837e2a392d5d59cf66c38e16cd42f82ef6a29c05b2214ed1712bbb1d67253" => :high_sierra
    sha256 "6bc2d4bd5ab4ba467f7d692fdd754def2f2af3a68a8451082bfd72bd1989f93a" => :sierra
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
