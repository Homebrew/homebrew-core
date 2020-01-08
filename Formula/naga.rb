class Naga < Formula
  desc "Terminal implementation of the Snake game"
  homepage "https://github.com/anayjoshi/naga/"
  url "https://github.com/anayjoshi/naga/archive/naga-v1.0.tar.gz"
  sha256 "7f56b03b34e2756b9688e120831ef4f5932cd89b477ad8b70b5bcc7c32f2f3b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a397ca0cf60725415818826e47fbf20c4b9cad2bc754128ece0d50279b715fd" => :catalina
    sha256 "0deef9e2936b7e5256c4f3e6f22c85389e3b8e53a586018854cbad3b983adc53" => :mojave
    sha256 "324d31a0ae721075843ff5e326f35efcd1a03d784e92ef8419b954b40a55fae3" => :high_sierra
    sha256 "8baa28b92a0d6970a857c859b11e4a1df878db5270f259bd3ccfe3b5f57f3303" => :sierra
    sha256 "6ff3dd51d1cdeed9364c36c25d1c2794f973e2927077eaeb251fa0dbfc48a531" => :el_capitan
    sha256 "fe303605603697993def097e9557a0dcec83d323a0b43d51fb1811108937da6c" => :yosemite
  end

  def install
    bin.mkpath
    system "make", "install", "INSTALL_PATH=#{bin}/naga"
  end

  test do
    assert_predicate bin/"naga", :exist?
  end
end
