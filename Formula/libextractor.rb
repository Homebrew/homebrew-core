class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftp.gnu.org/gnu/libextractor/libextractor-1.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/libextractor/libextractor-1.10.tar.gz"
  sha256 "9eed11b5ddc7c929ba112c50de8cfaa379f1d99a0c8e064101775837cf432357"
  license "GPL-3.0"

  bottle do
    sha256 "1f9781fe4c690eca0d719016cd4f23bd94890ae69cc30c4c1caa47d919286483" => :catalina
    sha256 "0929de2de549d871c775fb2b3aaf22dc52377b504b8ed3d01ca9350a52704e39" => :mojave
    sha256 "5a30c428cb327ef0bfd2458feeeb638200df28acf63b688d598a79591cb1c812" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"

  conflicts_with "csound", because: "both install `extract` binaries"
  conflicts_with "pkcrack", because: "both install `extract` binaries"

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
