class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.2.1/protobuf-c-1.2.1.tar.gz"
  sha256 "846eb4846f19598affdc349d817a8c4c0c68fd940303e6934725c889f16f00bd"
  revision 4

  bottle do
    sha256 "d38d06b1bc9886aaa0a5c684d5225f45d2cc6e9f1fff293bbcc49138b153065e" => :sierra
    sha256 "38460cedf85754bd7c8955fc773f55b60c497cbe190dd27930aafef676526118" => :el_capitan
    sha256 "1cf4e7b63dfb94ec7afaa793120be76fb63e9856559b38d231db8ff6e52ab534" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
