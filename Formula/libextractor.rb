class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftp.gnu.org/gnu/libextractor/libextractor-1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/libextractor/libextractor-1.8.tar.gz"
  sha256 "e235a4aa2623fe458f8fcf1dcbb5be4f03df509aacec86a1de1fc7fcca582cfc"

  bottle do
    sha256 "8a22082540795474049e3d2b8b8fd499c387de698c50be6a11da8cd1ca21ebd7" => :mojave
    sha256 "8042fd0b6753e11aa8d7391e45cec1514c0a9275dce0a5db9ced50b7be326103" => :high_sierra
    sha256 "f2b1bc7a199d77481aa81100f15fabddf4b3f460f139b089ff5910723c8ed4da" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"

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
