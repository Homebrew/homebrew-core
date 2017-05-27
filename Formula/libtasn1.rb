class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.11.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.11.tar.gz"
  sha256 "944a46b3199e878e24b945adf11ee44835a3ca95aacd56834fc97083db4a2241"

  bottle do
    cellar :any
    sha256 "389ef05d7f0a7db7a23bf7afc22bcf5c7eb78d81b66e439d8449c7bd3d661241" => :sierra
    sha256 "39d5d6eacce63452a1921f2d3d6d53ce277b946faf37eba3e2480f6269f74fdc" => :el_capitan
    sha256 "7b50181cb9672cf449035e2f55e0c43e1e1b393d60011631ec8c3fdc30413edb" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"pkix.asn").write <<-EOS.undent
      PKIX1 { }
      DEFINITIONS IMPLICIT TAGS ::=
      BEGIN
      Dss-Sig-Value ::= SEQUENCE {
           r       INTEGER,
           s       INTEGER
      }
      END
    EOS
    (testpath/"assign.asn1").write <<-EOS.undent
      dp PKIX1.Dss-Sig-Value
      r 42
      s 47
    EOS
    system "#{bin}/asn1Coding", "pkix.asn", "assign.asn1"
    assert_match /Decoding: SUCCESS/, shell_output("#{bin}/asn1Decoding pkix.asn assign.out PKIX1.Dss-Sig-Value 2>&1")
  end
end
