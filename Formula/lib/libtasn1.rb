class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftpmirror.gnu.org/gnu/libtasn1/libtasn1-4.21.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.21.0.tar.gz"
  sha256 "1d8a444a223cc5464240777346e125de51d8e6abf0b8bac742ac84609167dc87"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae01713eec0bd922b903ed2bf514dc085ec3108636c4ead84614b23a2c33f267"
    sha256 cellar: :any,                 arm64_sequoia: "973e0fd7d529808f53fa9ae281020bcbcc750a1dff60e5e5bc37c0da274cca5e"
    sha256 cellar: :any,                 arm64_sonoma:  "2dceab4bf93738bd4f3efd9063a5cf60ccd96e5b0e5a3ac9fca508e42b5f3336"
    sha256 cellar: :any,                 sonoma:        "71c5d144fdce79e4cfe7bbd5863da5171a13d892a26475c5ea183e7e3ef21d8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8b7973e5f6822f25876da6b60138eec386a3d3b9f0a694dff7b5a7073fcf82d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0394c5c9c0b278c37eb9f817a282054d64654f7b27eb86100bb5b307a0d72b5"
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
