class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.13.tar.gz"
  sha256 "7e528e8c317ddd156230c4e31d082cd13e7ddeb7a54824be82632209550c8cca"

  bottle do
    cellar :any
    sha256 "59e32566093c6528c2a8aa36086e2cadc067873f10cc85dc8b5613cf9daa4793" => :high_sierra
    sha256 "1ffba72aee8d79b0c97a2bb72f0dfab5b4d20052b01411be2b6815dbe485a375" => :sierra
    sha256 "90338dad72d15a370b546d28e4df67cce93dee33c5a442dfbc48f29654460e65" => :el_capitan
    sha256 "ddb2c3a87fad85b37b6a749d283d7f2adc8af9145c0a9d3c3c665624e6d95be5" => :yosemite
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
