class Asn1c < Formula
  desc "Compile ASN.1 specifications into C source code"
  homepage "https://lionet.info/asn1c/blog/"
  url "https://github.com/vlm/asn1c/releases/download/v0.9.28/asn1c-0.9.28.tar.gz"
  sha256 "8007440b647ef2dd9fb73d931c33ac11764e6afb2437dbe638bb4e5fc82386b9"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_big_sur: "fb9e9bcf79e03d772682d793cae01dcf56327295ec42907541f5a1467186992d"
    sha256 big_sur:       "5d7a47c30cba9b47d1cdb6a59ba824b60e9435bc977db2718e9cda8e023e3932"
    sha256 catalina:      "3a3f6f82a118d66043522ec62a31b34c9074193e43b7cda483c13b98aab35d2a"
    sha256 mojave:        "ca164013b7756e3e0362ed4aae3a7e3cc541e2963354ddfeb1f08d6a754b4a68"
    sha256 high_sierra:   "8b26526bf103e9b11b07b401a68bc86fb35d4d1ce6e62f6a1568dbc80bd86613"
    sha256 sierra:        "432aa83cf3a3f9db86435fe75330902b556885605446a477a3f55e9e0ac13806"
    sha256 el_capitan:    "be0a7e18cf6c2a3cf04831fb854247b26b6da96d3b56b3f8b3088fe3bd5c7668"
    sha256 yosemite:      "c9f31dc8f2f27a99370713ad9d5dfc1969ced862045bfa3680b48e85080277b5"
    sha256 x86_64_linux:  "ed036934421098b70439fb08246d7cb2c5cad95c2a97de80c13571e19b21c596"
  end

  head do
    url "https://github.com/vlm/asn1c.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.asn1").write <<~EOS
      MyModule DEFINITIONS ::=
      BEGIN

      MyTypes ::= SEQUENCE {
         myObjectId    OBJECT IDENTIFIER,
         mySeqOf       SEQUENCE OF MyInt,
         myBitString   BIT STRING {
                              muxToken(0),
                              modemToken(1)
                     }
      }

      MyInt ::= INTEGER (0..65535)

      END
    EOS

    system "#{bin}/asn1c", "test.asn1"
  end
end
