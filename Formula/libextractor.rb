class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftp.gnu.org/gnu/libextractor/libextractor-1.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/libextractor/libextractor-1.5.tar.gz"
  sha256 "e0c0305b1356d0cf2fc2db0784e4e5ae8c44121e1e5c6424552d9f9271943553"

  bottle do
    sha256 "3202875e248d691ac4cc59e3043aa41e41c63b6e84c8765c80d91493eae4540a" => :high_sierra
    sha256 "d293c0ceed9ff99a7b399677a7c3f8111097c4fd724dc25d7b270822f0ea0dbf" => :sierra
    sha256 "58bb8443f1e84ded693d7906f67b01faad162c51fa6fc673c6dbf3242db77095" => :el_capitan
    sha256 "511343d0e5d97180acb23f603b1d116368e547e56289c272a38e567ac0567f59" => :yosemite
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
