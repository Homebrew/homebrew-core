class Ballerburg < Formula
  desc "Castle combat game"
  homepage "https://baller.tuxfamily.org/"
  url "https://download.tuxfamily.org/baller/ballerburg-1.2.0.tar.gz"
  sha256 "0625f4b213c1180f2cb2179ef2bc6ce35c7e99db2b27306a8690c389ceac6300"
  head "https://git.tuxfamily.org/baller/baller.git"

  bottle do
    cellar :any
    sha256 "e31d8c383d0abfbd5ff700683d225b3d34345cd9c89c8fdaec34813cfbee47d2" => :mojave
    sha256 "23ecdb1ee06b96cff2e51117b3ff0bf8f0b6f29195e3d2d6323ca8dd72c79074" => :high_sierra
    sha256 "fa38cec8799ff4dcd33735146d4d93c986eb42c72bf6a9f1b3bd997acb5613c1" => :sierra
    sha256 "314236d328ffdbaa4ddbcfbe38566ab0669df3935a9a051d3366a8d0e87d3de9" => :el_capitan
    sha256 "46502878f24bf976bc5798ff74c145059f642ca2e9cb9d8467e296ad5b582f00" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "sdl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
