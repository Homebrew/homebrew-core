class Ballerburg < Formula
  desc "Castle combat game"
  homepage "http://baller.tuxfamily.org/"
  url "http://download.tuxfamily.org/baller/ballerburg-1.2.0.tar.gz"
  sha256 "0625f4b213c1180f2cb2179ef2bc6ce35c7e99db2b27306a8690c389ceac6300"
  head "http://git.tuxfamily.org/baller/baller.git"

  bottle do
    cellar :any
    sha256 "2a8049ab07afdd51322f517a8ecdab9a13f77a7e49c7fa37a6ba1ed09ced9321" => :yosemite
    sha256 "8fe0ceaf918f821a279ccfc312f808610caa95c06ccdab27fe3285eef86f18ff" => :mavericks
    sha256 "5fe9dde09b27b72048482631b90a2e185140e3e84e0e33c5ebff57082a31746c" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "sdl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
