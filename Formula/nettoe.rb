class Nettoe < Formula
  desc "Tic Tac Toe-like game for the console"
  homepage "https://nettoe.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nettoe/nettoe/1.5.1/nettoe-1.5.1.tar.gz"
  sha256 "dbc2c08e7e0f7e60236954ee19a165a350ab3e0bcbbe085ecd687f39253881cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "59cab1291f69cb1c35a269d18343a3d07eaf55d6f0d178c9548afb282497fc50" => :catalina
    sha256 "2d45bfae915cfc4425e45393a9868c4e586379c05e61f35aaf704cc54376c17c" => :mojave
    sha256 "0349c1335e428d5f0b620043259908b5af60feed84d9dea911033e0d65704488" => :high_sierra
    sha256 "49ad705043bdd9f1ab860d877d3ffba584bef5ddbd4c03f6fe43adc49b9c1e5d" => :sierra
    sha256 "c8208683e4730233147e6c7153a469cdc1f477aacde0559937f0da93c8ad0345" => :el_capitan
    sha256 "78038d253cd382f5f3a6b3b12c7776828c44c1572f0569bec862763aa5141c2a" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /netToe #{version} /, shell_output("#{bin}/nettoe -v")
  end
end
