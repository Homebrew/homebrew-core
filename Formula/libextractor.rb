class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftp.gnu.org/gnu/libextractor/libextractor-1.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/libextractor/libextractor-1.6.tar.gz"
  sha256 "26d4adca2e381d2a0c8b3037ec85e094ac5d40485623794466cfc176f5bbf69d"

  bottle do
    sha256 "d547400beebeae3290adfa6d63add9b9c722d4dd65533e77a4be0b8bf315b8c5" => :high_sierra
    sha256 "af73939dbc95fb9f2ed2bfcbf8217cff2b07a9f0716cfedbaaa57c03321f3d16" => :sierra
    sha256 "10267b6dd613e42a5335b2ed4b06f47319cfbfcee2a4455f32fe216d9cbd630d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
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
