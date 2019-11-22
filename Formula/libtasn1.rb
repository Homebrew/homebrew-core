class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.15.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.15.0.tar.gz"
  sha256 "dd77509fe8f5304deafbca654dc7f0ea57f5841f41ba530cff9a5bf71382739e"

  bottle do
    cellar :any
    sha256 "f1988371a72d252ecf69f2c39d61a8ad01cb49dd84ea716f00e38a2a74ff5ee0" => :catalina
    sha256 "2e13d55178c6a4c057dbef42599700d06d7ef4192500b9254ff5cd99d5a07167" => :mojave
    sha256 "1cf05b98fcb012d92efad23aaf68ba67e9edd7e15813f2b8826878d15b1ba189" => :high_sierra
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
