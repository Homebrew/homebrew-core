class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v3.1.1.tar.gz"
  sha256 "2664af92b1752225ec66656bac4052aad8a8d4ff26cadeb15606ec5f00f9ed97"

  bottle do
    cellar :any_skip_relocation
    sha256 "883df2b98db4e74b9c7a963d3b9562b4714e83a3601a37668c1bd134443d0557" => :catalina
    sha256 "981bbb94eb21af293480eef635094063815fb13dc7d672d03b379684817af840" => :mojave
    sha256 "25038963829236bc0ffa02d8a6ffc4120d2a3e0eccd5248d2bfab969f6c2a0b0" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
