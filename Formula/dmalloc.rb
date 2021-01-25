class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage "https://dmalloc.com/"
  url "https://dmalloc.com/releases/dmalloc-5.6.5.tgz"
  sha256 "480e3414ab6cedca837721c756b7d64b01a84d2d0e837378d98444e2f63a7c01"
  license "ISC"

  bottle do
    cellar :any_skip_relocation
    sha256 "300f9e7b54c15071bc36fb861cc6b75ef671052c8be6096a99314b1ca0077565" => :big_sur
    sha256 "c8e1beff8a66f4a5d7a90fa8c5f9836ed79b9241ab642966d82550916a3af5c1" => :arm64_big_sur
    sha256 "770699ff908a65026ecdebbe57272a50e57f60341c2918302ee4b6729e866533" => :catalina
    sha256 "40c8cf6501477c243064179e7b634da0d9d32348155d3aee9fbf6631ffdc7ba7" => :mojave
  end

  def install
    system "./configure", "--enable-threads", "--prefix=#{prefix}"
    system "make", "install", "installth", "installcxx", "installthcxx"
  end

  test do
    system "#{bin}/dmalloc", "-b", "runtime"
  end
end
