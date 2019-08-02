class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.14.tar.gz"
  sha256 "9e604ba5c5c8ea403487695c2e407405820d98540d9de884d6e844f9a9c5ba08"

  bottle do
    cellar :any
    sha256 "54a78a69c7f881f66511b224b11f84448acfa2dd40428e3a8ce77bd3481f2c98" => :mojave
    sha256 "570ea4d01af3014b275b5bb68cc4bcf7881c305b7cfce8046d81df64422a7c14" => :high_sierra
    sha256 "e7a9b411a1d658d8d9401a630471fc3736d0f8564b8620dc50c488a5ee52cd83" => :sierra
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
