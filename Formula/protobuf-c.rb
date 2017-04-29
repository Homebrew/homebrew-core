class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.2.1/protobuf-c-1.2.1.tar.gz"
  sha256 "846eb4846f19598affdc349d817a8c4c0c68fd940303e6934725c889f16f00bd"
  revision 4

  bottle do
    sha256 "2756ed64ca2ef77170f75971e0bf08b08532061207f939c66c87e85a0a175a81" => :sierra
    sha256 "ef65dd29ed1e11b7250c0b4a98dfe1dc55b2221212fa71c39201a354490399ad" => :el_capitan
    sha256 "13035d9719f8aff31ee8f4fad6efa3dfe9f8608964db90691faa03fc0cc66539" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
