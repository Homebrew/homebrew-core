class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.2.1/protobuf-c-1.2.1.tar.gz"
  sha256 "846eb4846f19598affdc349d817a8c4c0c68fd940303e6934725c889f16f00bd"

  bottle do
    sha256 "a61f29e1908a243e5fdc365eac9c055ec84b4c120e99d46bb6a843b62db53844" => :el_capitan
    sha256 "178f84dfb66628862e08a3bf58c5a0bdb1a6624f4de63d1670832ea394b5c04d" => :yosemite
    sha256 "50c184193ace913ed581c66669418f4755e4ac44428a9383e10d6178022664aa" => :mavericks
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
