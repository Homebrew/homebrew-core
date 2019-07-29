class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.13.tar.gz"
  sha256 "7e528e8c317ddd156230c4e31d082cd13e7ddeb7a54824be82632209550c8cca"

  bottle do
    cellar :any
    sha256 "3e18c28faee5c976dd1121790dcb69ed53c98f99ef723903fbcadcf5cf85f577" => :mojave
    sha256 "5908b018a38a3f60195eae854d5ab61f93fde8e9179d5ab8cab720b8c41182ba" => :high_sierra
    sha256 "4dcc5ff1b54a1d0426acc4b3f32d7c929d0f07f52f6f699d0f5f50839e047b5d" => :sierra
    sha256 "acd0abd3cb4ec5fb7be28c28963c256e57f18ada4b1ad58c68e2a463cdf449ea" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"pkix.asn").write <<~EOS
      PKIX1 { }
      DEFINITIONS IMPLICIT TAGS ::=
      BEGIN
      Dss-Sig-Value ::= SEQUENCE {
           r       INTEGER,
           s       INTEGER
      }
      END
    EOS
    (testpath/"assign.asn1").write <<~EOS
      dp PKIX1.Dss-Sig-Value
      r 42
      s 47
    EOS
    system "#{bin}/asn1Coding", "pkix.asn", "assign.asn1"
    assert_match /Decoding: SUCCESS/, shell_output("#{bin}/asn1Decoding pkix.asn assign.out PKIX1.Dss-Sig-Value 2>&1")
  end
end
