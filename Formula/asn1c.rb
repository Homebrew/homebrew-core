class Asn1c < Formula
  desc "Compile ASN.1 specifications into C source code"
  homepage "http://www.lionet.info/asn1c/"
  url "https://github.com/vlm/asn1c/releases/download/v0.9.28/asn1c-0.9.28.tar.gz"
  sha256 "8007440b647ef2dd9fb73d931c33ac11764e6afb2437dbe638bb4e5fc82386b9"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "d4a15a7420fc9ccf67b43823f117ff4ba4ecd8db6686ad2ed2748a3375d00c9b"
    sha256 arm64_big_sur:  "25ad95ded32395974dee8fdf8d0e5f7e2dc7cebd38ff0082a13cd3e52677f329"
    sha256 monterey:       "a3999e6443202ae87c2c44823efb4ce4939838124f870cccbf19d8be61a01974"
    sha256 big_sur:        "d3db341a38f139efbea8f9d2f70912af6e80d4f9cd0b472f2f6202bcd31431b3"
    sha256 catalina:       "a7688d139182258a7377b3a30cf57ef3ff95c184940bcb171d0968c2c152f65f"
    sha256 x86_64_linux:   "fe7fa5f68ab94a7d748a2af7451d496192c7bc543bd9dc9c660673cb8026bda4"
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
