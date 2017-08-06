class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.0/protobuf-c-1.3.0.tar.gz"
  sha256 "5dc9ad7a9b889cf7c8ff6bf72215f1874a90260f60ad4f88acf21bb15d2752a1"

  bottle do
    sha256 "e5f44ef7b504b7744ec4bc51f194e49861885cf0c0278f16386d216c80390ef5" => :sierra
    sha256 "c3484962cab3d35bad7632379958566cad1318e7a03180950852089227316372" => :el_capitan
    sha256 "b747524137691a433e44fb7ab5015cdb73425c70e5fd07be2d40b9601abfd6d4" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
