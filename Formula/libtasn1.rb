class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.10.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.10.tar.gz"
  sha256 "681a4d9a0d259f2125713f2e5766c5809f151b3a1392fd91390f780b4b8f5a02"

  bottle do
    cellar :any
    sha256 "d01becdbdb8f633a60ee87d3a8323bd7e175874e32944667e3592a90da479b2b" => :sierra
    sha256 "2d7b27ee64a21b6d23dbe0d55bf1140704eb78911555d848f4a6a5846818a405" => :el_capitan
    sha256 "5d24dc6645c06b92219f52c15ffeea3ab2149da9cf2a1c33cb10131f6244179b" => :yosemite
    sha256 "5fb8522427e23d95e572f9f25c8a37b3bd6b8e4747446bb0b4e3954e816d4bf8" => :mavericks
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
