class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftp.gnu.org/gnu/libextractor/libextractor-1.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/libextractor/libextractor-1.5.tar.gz"
  sha256 "e0c0305b1356d0cf2fc2db0784e4e5ae8c44121e1e5c6424552d9f9271943553"

  bottle do
    sha256 "c460b8b012f195be5cc7b645a4bf59e1f44b28573ce11cb95f19a71b421589ad" => :high_sierra
    sha256 "061b876308d65624e9f10e32b0f1f8f7f464f8329d7e069e813f572fc2b5056c" => :sierra
    sha256 "feae38f770372b26b97f3bb627145a232d6b1504357d5c4dbedeb5ccc560a132" => :el_capitan
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
