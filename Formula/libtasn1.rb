class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.8.tar.gz"
  sha256 "fa802fc94d79baa00e7397cedf29eb6827d4bd8b4dd77b577373577c93a8c513"

  bottle do
    cellar :any
    sha256 "2dfd9c6d3fff5b8f614c4b8961f1b03b14af9343b39e0e1802f98d888099c4bc" => :el_capitan
    sha256 "7fbfff75df1ea7313b427c4f20ad0f8906c4d7a0dcc8ae1c74d362ca3b6fd4ff" => :yosemite
    sha256 "5552be95a8ae3e4522f906d1b967215e2387e0b547a3c15409a6a1a3bea774e7" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
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
