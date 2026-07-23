class Asn1c < Formula
  desc "Compile ASN.1 specifications into C source code"
  homepage "https://lionet.info/asn1c/blog"
  url "https://github.com/vlm/asn1c/archive/refs/tags/v0.9.29.tar.gz"
  sha256 "cdcfa0638d9657da3b114ceef3d6c9919e9e1e4da0de49456f8d9e398826d5ab"
  license "BSD-2-Clause"
  head "https://github.com/vlm/asn1c.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "8271932dbd1a2224cd82a27e85adc02805d163505891baaa5616634b9feca1a4"
    sha256 arm64_sequoia: "a09dd4a70cd271295ba8e8a795499fc27930fe234f29d30edb24fdff25aee0ef"
    sha256 arm64_sonoma:  "5fc2806bdf049a732b54cbab5f6a210572b3b1b2d59bd8478594f8667775a2de"
    sha256 sonoma:        "f62c5969a4ea7e0c30c7a8ae50d9a7403127ab6655de1d24fef9918ec9d76002"
    sha256 arm64_linux:   "ad53d2b5cff9b8e89a84795cc74da7ec0d4fcebfc7d8b89abd430d7a3525c384"
    sha256 x86_64_linux:  "5b56600cc4f902d1173c3dddaf7a5052ef36c63b0e8268eb817279aa39abb318"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--mandir=#{man}", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.asn1").write <<~ASN1
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
    ASN1

    system bin/"asn1c", "test.asn1"
  end
end
