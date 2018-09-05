class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftp.gnu.org/gnu/libextractor/libextractor-1.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/libextractor/libextractor-1.7.tar.gz"
  sha256 "e0a6fde824cf2212c4f217a5e0fc03391251cfb46ca000117f66cf7ae4368e8f"

  bottle do
    sha256 "5657972b2813b8c6aaa585cb97ca9de5eda35b9ab282e815b51ab2522f939acd" => :mojave
    sha256 "85a1c132a16157d6d5b4836591b4a2921c7cc15a7a7facc3c33653e183530765" => :high_sierra
    sha256 "e371b24c935eb79d24edd5a9a65d2865dee6219c3e5c4f2f65b40de703b8ee00" => :sierra
    sha256 "8b59442f5b46f6dea1e1e5df34943db009dcf017b1e47f2fe3cc45b0384a5c40" => :el_capitan
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
