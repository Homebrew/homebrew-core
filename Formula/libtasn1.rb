class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.19.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.19.0.tar.gz"
  sha256 "1613f0ac1cf484d6ec0ce3b8c06d56263cc7242f1c23b30d82d23de345a63f7a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9fcf93a7992888a29caf2bc3ad37fb27ee8ceef180367797f4a11040fa761eac"
    sha256 cellar: :any,                 arm64_monterey: "cf95a18e2fabf1675d77ec8a1abb41fdb091cef689dec3318a420ad2f25beb76"
    sha256 cellar: :any,                 arm64_big_sur:  "19c6df6badb6b13631670b917595f63a49a06cadd73e2484e5546129cadcf04c"
    sha256 cellar: :any,                 ventura:        "ee3b036d7d82561e743131c0ec97d4a425e18a593253830753c519a04db6b200"
    sha256 cellar: :any,                 monterey:       "2aa4f8396ba40b05b237d503eb4de02c37175903d3e0f26d7a48a031707a71b5"
    sha256 cellar: :any,                 big_sur:        "45a9352536560b5a69bef3e85ca615bad19d44eab23c6ad797c4305a27bd15d8"
    sha256 cellar: :any,                 catalina:       "7bf11a4603037c490e83caaddc03fba59dfae11385e2f6bd4555b8ee9aaf1507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e994c7b8c16afb59368d8d09a3f193451c9deab1e4a83f8a94650e27674d9278"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "check"
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
