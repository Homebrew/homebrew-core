class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.18.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.18.0.tar.gz"
  sha256 "4365c154953563d64c67a024b607d1ee75c6db76e0d0f65709ea80a334cd1898"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f85aa10d1320087405fd8b5c17593c6238bac842c6714edd09194f28e8e9f25d"
    sha256 cellar: :any,                 arm64_big_sur:  "1d79a03efd060b5bca10609a841f44f1444e2bb7bab149e3bb624b6bf5806418"
    sha256 cellar: :any,                 monterey:       "ddaf57bdd4f54323ae30093fbfe3aef9758423b03caf2c4757d592c7c7418e08"
    sha256 cellar: :any,                 big_sur:        "dc2e936192de2c028feb09681b615d0858d8f29a740ed0cdd0fc50a7265fd363"
    sha256 cellar: :any,                 catalina:       "2c8cc66c96bdbb7e02304cd00fe80d3e5decef3a03cace1827e9de6e1dd0397c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9964622a7285ce7dbcdc713804d18fc9de0ce1db5037198de69b91fdb3a7f062"
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
