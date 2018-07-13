class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftp.gnu.org/gnu/libextractor/libextractor-1.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/libextractor/libextractor-1.7.tar.gz"
  sha256 "e0a6fde824cf2212c4f217a5e0fc03391251cfb46ca000117f66cf7ae4368e8f"

  bottle do
    sha256 "d547400beebeae3290adfa6d63add9b9c722d4dd65533e77a4be0b8bf315b8c5" => :high_sierra
    sha256 "af73939dbc95fb9f2ed2bfcbf8217cff2b07a9f0716cfedbaaa57c03321f3d16" => :sierra
    sha256 "10267b6dd613e42a5335b2ed4b06f47319cfbfcee2a4455f32fe216d9cbd630d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "iso-codes" => :optional

  conflicts_with "pkcrack", :because => "both install `extract` binaries"

  def install
    ENV.deparallelize

    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match /Keywords for file/, shell_output("#{bin}/extract #{fixture}")
  end
end
