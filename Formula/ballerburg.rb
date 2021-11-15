class Ballerburg < Formula
  desc "Castle combat game"
  homepage "https://baller.tuxfamily.org/"
  url "https://download.tuxfamily.org/baller/ballerburg-1.2.0.tar.gz"
  sha256 "0625f4b213c1180f2cb2179ef2bc6ce35c7e99db2b27306a8690c389ceac6300"
  license "GPL-3.0"
  head "https://git.tuxfamily.org/baller/baller.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ballerburg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e0d4b0b00f1b5086547a78dafc9df47493908ebad32dee347200958745990606"
    sha256 cellar: :any,                 arm64_big_sur:  "a82163254a4f1ff916e0d7ba0387914f529ffa67955495e146be69b5c2b2f31e"
    sha256 cellar: :any,                 monterey:       "86a27de26ac3557733cec8e78d1c65ee34dca91374649947052cd51032132764"
    sha256 cellar: :any,                 big_sur:        "94691e7d7c914ce603ffdcf611159d2fd8fa63616f9f35f6bed3c58d72571bea"
    sha256 cellar: :any,                 catalina:       "5459d5bc2baba43a0ad3a32dde1c3e6adbd02dfdce1f43bcb4c1d9ebf8f73b01"
    sha256 cellar: :any,                 mojave:         "e31d8c383d0abfbd5ff700683d225b3d34345cd9c89c8fdaec34813cfbee47d2"
    sha256 cellar: :any,                 high_sierra:    "23ecdb1ee06b96cff2e51117b3ff0bf8f0b6f29195e3d2d6323ca8dd72c79074"
    sha256 cellar: :any,                 sierra:         "fa38cec8799ff4dcd33735146d4d93c986eb42c72bf6a9f1b3bd997acb5613c1"
    sha256 cellar: :any,                 el_capitan:     "314236d328ffdbaa4ddbcfbe38566ab0669df3935a9a051d3366a8d0e87d3de9"
    sha256 cellar: :any,                 yosemite:       "46502878f24bf976bc5798ff74c145059f642ca2e9cb9d8467e296ad5b582f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce02fc59db3ed286e5a811707e57db838aa756981ef7b6614d876573dc4513a8"
  end

  depends_on "cmake" => :build
  depends_on "sdl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
