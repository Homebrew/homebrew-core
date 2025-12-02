class Asn1c < Formula
  desc "Compile ASN.1 specifications into C source code"
  homepage "https://lionet.info/asn1c/blog"
  url "https://github.com/vlm/asn1c/releases/download/v0.9.28/asn1c-0.9.28.tar.gz"
  sha256 "8007440b647ef2dd9fb73d931c33ac11764e6afb2437dbe638bb4e5fc82386b9"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "101f876e913d345e99ac08ef2e9144b578e3979491f8338a62cf3c0e0d346144"
    sha256 arm64_sequoia:  "92cbad00b77b014b9fc957b1fe1c3ceafe01c367355dbbce6b92321aa5dcacda"
    sha256 arm64_sonoma:   "81853752cb0f9b91cf9fa95ec52a83ae7a59c21f4aac0f09b213f45bff3f303e"
    sha256 arm64_ventura:  "3d72779b69c5ad5f2bf006ca514ad77d6cadf7512f5f8e21e7f7ca07399ff799"
    sha256 arm64_monterey: "d4a15a7420fc9ccf67b43823f117ff4ba4ecd8db6686ad2ed2748a3375d00c9b"
    sha256 arm64_big_sur:  "25ad95ded32395974dee8fdf8d0e5f7e2dc7cebd38ff0082a13cd3e52677f329"
    sha256 sonoma:         "72e535073c4021897bcf9a79d2032a6375d59c60fd95d512d5b2f50b4f0d93b3"
    sha256 ventura:        "40bcecf237baa2b3f51a6211ef981a515269e5aa243e862b3852d0cda417c662"
    sha256 monterey:       "a3999e6443202ae87c2c44823efb4ce4939838124f870cccbf19d8be61a01974"
    sha256 big_sur:        "d3db341a38f139efbea8f9d2f70912af6e80d4f9cd0b472f2f6202bcd31431b3"
    sha256 catalina:       "a7688d139182258a7377b3a30cf57ef3ff95c184940bcb171d0968c2c152f65f"
    sha256 arm64_linux:    "1cf47d0986b911c566f919454694f2abc20927425eb4b002d1761c2e9c8d714a"
    sha256 x86_64_linux:   "fe7fa5f68ab94a7d748a2af7451d496192c7bc543bd9dc9c660673cb8026bda4"
  end

  head do
    url "https://github.com/vlm/asn1c.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--mandir=#{man}", *args, *std_configure_args
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

    system bin/"asn1c", "test.asn1"
  end
end
