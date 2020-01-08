class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v3.0.0.tar.gz"
  sha256 "7a95e3d16d4af52d9a6882b5912ffaaf5bb41a5a45652565114c018dbdd64dac"

  bottle do
    cellar :any_skip_relocation
    sha256 "b459b1d029abbe94bb3e65b2c66045c4f37673ccb5ad140b87c20ae648dd3875" => :catalina
    sha256 "9ebd55d251a8d939569a5ae1c2b882f4a89c52e0f545716f0470c63aa94b6c15" => :mojave
    sha256 "79e6906b19db7e058014e7f3fe462437c03a15de0d68a974f9e3cb91f8b9deec" => :high_sierra
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
