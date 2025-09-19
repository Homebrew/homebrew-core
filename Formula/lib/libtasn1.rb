class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftpmirror.gnu.org/gnu/libtasn1/libtasn1-4.20.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.20.0.tar.gz"
  sha256 "92e0e3bd4c02d4aeee76036b2ddd83f0c732ba4cda5cb71d583272b23587a76c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c8b872f9b9bda9d74184575f84a277ea8cb32c49c60c5615cd2b0ebcd2279d9a"
    sha256 cellar: :any,                 arm64_sequoia: "e847b97b86b1caab2eff1498c82c411459e1e7c176de72e6c53aed4528ab80ce"
    sha256 cellar: :any,                 arm64_sonoma:  "8a2d13e7d0c687470f2be9e213432b93c22d3ab9b674fce2a950d7eb45432cac"
    sha256 cellar: :any,                 arm64_ventura: "b202c24f2e22f7f709473f72ec9c26f3ec43d643b8488378690c83fd96d48d69"
    sha256 cellar: :any,                 sonoma:        "75cccbdfc213e905656c372ca5b9496cf88dea3a0fd9dcb032f06bbdd061228b"
    sha256 cellar: :any,                 ventura:       "544067beee3846eafd9a1ecdd5d25646d8ff3f417f5f2e464441b0a2c6a19b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec6abf595dd54b05c55662226b05301d9e27b3e61f427866b1ba7686d01f8633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a141f58624a57f3370d4ed714225a78f24bddbb6a3b60ed82127614090cdb9d9"
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

    system bin/"asn1Coding", "pkix.asn", "assign.asn1"
    assert_match "Decoding: SUCCESS", shell_output("#{bin}/asn1Decoding pkix.asn assign.out PKIX1.Dss-Sig-Value 2>&1")
  end
end
