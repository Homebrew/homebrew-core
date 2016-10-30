class Lzlib < Formula
  desc "Data compression library"
  homepage "http://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.8.tar.gz"
  sha256 "41bfa82c6ee184ed0884437dc4074ad505e64cb747432cefa97976b89045cbad"

  bottle do
    cellar :any_skip_relocation
    sha256 "026dbd89a759e89bb934b17e935bc75dc32516d1c8722ec52f2b8dbf3d3b4678" => :sierra
    sha256 "4c90f6b740eb6fea8fef693744a071c268ab1655a1b077ae6ddc582e8fe2fc6f" => :el_capitan
    sha256 "5964828d701a9f8f16d3d72f2725b08bfbf34816885f8dcede60a02f3bbc188c" => :yosemite
    sha256 "27ff9c5ce28a58317f5a77cff0b23ceef648774d984b89cf0b1f96066149036b" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
