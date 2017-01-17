class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.1.0.tar.gz"
  sha256 "bcc96aaa609daae4d3f7ab1ee480126709ef4f6a8bf9c85de40aae48e38cce66"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "b09efe9e43cf67e2efe96906df774609296eb2e2d2f56701b5bf6ff3548647ca" => :sierra
    sha256 "702a65dbc2965cf2f34bf25f53d3ac3d69330e85136d2da31772261b00158e19" => :el_capitan
    sha256 "3b5763bf2588ed7d7e3b985f8d15b47ea1624523c5ec87b3fe980b1397b85f0d" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
