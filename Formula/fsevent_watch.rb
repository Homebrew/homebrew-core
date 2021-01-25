class FseventWatch < Formula
  desc "macOS FSEvents client"
  homepage "https://github.com/proger/fsevent_watch"
  url "https://github.com/proger/fsevent_watch/archive/v0.2.tar.gz"
  sha256 "1cfd66d551bb5a7ef80b53bcc7952b766cf81ce2059aacdf7380a9870aa0af6c"
  license "MIT"
  head "https://github.com/proger/fsevent_watch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3450ed18ee786ff504e23bcd1d188511782661d49d9025be30227fefc43a30b8" => :big_sur
    sha256 "677477269a68d09467089624e2a0c7047daddbbac0db208c01bed88d08595bc4" => :arm64_big_sur
    sha256 "7947abb87aa8cc18551b2931374c7fc9a91503a8b637762360f67ad7fdcdc5ec" => :catalina
    sha256 "4f9c9f11ee85b971d840b9b3626ed55c7b9160308900de2278a7b159a384f0f0" => :mojave
  end

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}", "CFLAGS=-DCLI_VERSION=\\\"#{version}\\\""
  end

  test do
    system "#{bin}/fsevent_watch", "--version"
  end
end
