class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftp.gnu.org/gnu/libextractor/libextractor-1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/libextractor/libextractor-1.9.tar.gz"
  sha256 "f08f257d26c5e9b503f068d6753c8e55cb76f47f73a81da6ed2bba3de3fee2ff"

  bottle do
    sha256 "05f3281584bd5a64cee246033510bdd0e04674785576db58759c1c5ddb8acc6d" => :catalina
    sha256 "7e0ed720f6c76d148affdccfdffd70285114e03063ef10711ab207ba52d753f7" => :mojave
    sha256 "3feba61ae58271eb373e0f215e5e857e1709b7ae6cfeb222d7be8bf302b8a219" => :high_sierra
    sha256 "5ae5f5a6335e1bc2f2c9d5a9d6206cadd99de6da11594eb87e52ca148bedd1b0" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"

  conflicts_with "csound", :because => "both install `extract` binaries"
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
