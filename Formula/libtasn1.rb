class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.17.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.17.0.tar.gz"
  sha256 "ece7551cea7922b8e10d7ebc70bc2248d1fdd73351646a2d6a8d68a9421c45a5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a5a79346194afa5a466d36f07aee16700be211a92e6cbddd522fb252dd6b1b5b"
    sha256 cellar: :any, big_sur:       "367dc37e3bcb626de815129016cb106aa39ca8c2e8c3c9c5904b8da763b10e9f"
    sha256 cellar: :any, catalina:      "09f4b0b626425f10665ff506c2dca70101ae9062b284b956197d7e88c91d952c"
    sha256 cellar: :any, mojave:        "384a48716bc3b0fa7122c2fbd3a1ab4a93087acee7191710fa5bbbfa31e0f24f"
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
    assert_match "Decoding: SUCCESS", shell_output("#{bin}/asn1Decoding pkix.asn assign.out PKIX1.Dss-Sig-Value 2>&1")
  end
end
