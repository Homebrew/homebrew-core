class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.17.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.17.0.tar.gz"
  sha256 "ece7551cea7922b8e10d7ebc70bc2248d1fdd73351646a2d6a8d68a9421c45a5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8b8ba758c8cb70a6970c69801937090ca5bc3fb68f9fb5358f2183299fbee3fa"
    sha256 cellar: :any,                 big_sur:       "a045a7b16828e7c18bad248feb37207815daea23ff313c1cd6e94e94b222bb73"
    sha256 cellar: :any,                 catalina:      "0b0b6a4b18ff4aef03772082d153be836b406af22e678a0b61553c70fdf95f10"
    sha256 cellar: :any,                 mojave:        "73201deae5a10cd4b4125b4a7c811f48ed861cd6fe2f82d69fed6003115d7bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4599c1f1a9b4858cbf688524cbdec6c412004b447102c034662781e0d96481"
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
