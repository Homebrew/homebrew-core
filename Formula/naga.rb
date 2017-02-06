class Naga < Formula
  desc "Terminal implementation of the Snake game"
  homepage "https://github.com/anayjoshi/naga/"
  url "https://github.com/anayjoshi/naga/archive/naga-v1.0.tar.gz"
  sha256 "7f56b03b34e2756b9688e120831ef4f5932cd89b477ad8b70b5bcc7c32f2f3b3"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d463ce4c2bab8ca72fcdee4545592a5de2d4eb4c30ae83d8bc7e59aff65b9b37" => :el_capitan
    sha256 "c1e7b2d084acd6f9c902dd012f56c3f4bb0e8e6482cea24d6416dcd9ec5fe540" => :yosemite
    sha256 "79beeb5cf00056d30ca4ca8173b6c992d562ab4b948e62d636fbc599b17a9bba" => :mavericks
  end

  def install
    bin.mkpath
    system "make", "install", "INSTALL_PATH=#{bin}/naga"
  end

  test do
    File.exist? "#{bin}/naga"
  end
end
