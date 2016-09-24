class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.2.1/protobuf-c-1.2.1.tar.gz"
  sha256 "846eb4846f19598affdc349d817a8c4c0c68fd940303e6934725c889f16f00bd"
  revision 2

  bottle do
    sha256 "6a457b9bb03045e5a588358b0e0cc6413cafeb0871d2239c0e556da9d87cf0f3" => :sierra
    sha256 "bcd2adfa85afe9057c35b971d796396b3cc77f3698ffff167c166c54bbc56313" => :el_capitan
    sha256 "cdadcb2c34ea509130bd927d506acb7b4016de77f39419c07fbd629e3cfebb1f" => :yosemite
    sha256 "d17bdc061c6f65c82a9fc7a468a8748aed5e262fd7b81df0a69da80620cb2a01" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
