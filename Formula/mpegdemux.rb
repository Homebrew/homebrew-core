class Mpegdemux < Formula
  desc "MPEG1/2 system stream demultiplexer"
  homepage "http://www.hampa.ch/mpegdemux/"
  url "http://www.hampa.ch/mpegdemux/mpegdemux-0.1.4.tar.gz"
  sha256 "0067c31398ed08d3a4f62713bbcc6e4a83591290a599c66cdd8f5a3e4c410419"

  bottle do
    cellar :any_skip_relocation
    sha256 "daa143e087fe5d35e5deda8dd37637b54ba908ba34d050beb0b42b3697b1f67c" => :mojave
    sha256 "af6cd127b024079f9584533b143094cbcdb97693007eaffcb6f967942d471712" => :high_sierra
    sha256 "2a1bae657b91607e47b201f2d97749def3c771911208db70c278bf4a47f4fd7e" => :sierra
    sha256 "4f00eabfededc549d4f419b6e6bf7896dbff0c95e83fda5f47067bf73294289b" => :el_capitan
    sha256 "322f5cf622b25ea9e907e1eb8d1f0ce172672ed91a0592d2621019f3b4159947" => :yosemite
    sha256 "baa0e3b7dffa4d3017c5639a0e07702b10e8913b87987e3c7235bbfae757fa0e" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/mpegdemux", "--help"
  end
end
