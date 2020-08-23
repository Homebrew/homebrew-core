class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20200330.tgz"
  sha256 "e099e2dd8a684d739ac6b9a0e43d468314a5bc34fd21466502d120b18df51fb0"

  bottle do
    cellar :any_skip_relocation
    sha256 "720be331b73d9d96ab6132e804413990c6ce224322071972634b4175d2289188" => :catalina
    sha256 "06a2014523f5c2efedefa5463275a441ada57a50d61a4f801d8c503d0406bde8" => :mojave
    sha256 "37c98bb69ca30ceee1ed62383b98ae1ca639f2b52e224baf0b71d5616244c638" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
