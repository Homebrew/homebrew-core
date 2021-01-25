class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.16.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.16.0.tar.gz"
  sha256 "0e0fb0903839117cb6e3b56e68222771bebf22ad7fc2295a0ed7d576e8d4329d"
  license "LGPL-2.1"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "9a69770cae180c61ada4bb4701f5402b35b828d2baa7c5135196cf1df35965cb" => :big_sur
    sha256 "e5ff2498ab8bcc108dd6797fede68929ae3fd2796c39e349ff3f8e0a87abb7a0" => :arm64_big_sur
    sha256 "00bd968b6a110c5cb497cf0e3b14800ed5e67a2476d0d544aeb1c0c2c1f3f332" => :catalina
    sha256 "3c2e9cdfec0ccec899847a3ab69b88967b6cbc0b3e406fa1938a4ca6f277b674" => :mojave
    sha256 "c3cf713b5bb29fcac1381b7242e557b7920cb327c77170a6dd038a477d6021cd" => :high_sierra
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
