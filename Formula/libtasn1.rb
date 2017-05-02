class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.10.tar.gz"
  sha256 "681a4d9a0d259f2125713f2e5766c5809f151b3a1392fd91390f780b4b8f5a02"

  bottle do
    cellar :any
    sha256 "1e45fba493969f7aebeaffd3037873588efb3faff69b5d41c0e4fec658c0feaa" => :sierra
    sha256 "5a0f0cfa1ec36351e833a2bd9ce5a8fb2575520334b30abb0da5dc43727415c1" => :el_capitan
    sha256 "e506e5613818094ab8029cbf94b51068e7f1d1683bcc5bc6b06c84eb9be2576d" => :yosemite
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
