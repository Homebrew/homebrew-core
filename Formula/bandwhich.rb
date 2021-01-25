class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.20.0.tar.gz"
  sha256 "4bbf05be32439049edd50bd1e4d5a2a95b0be8d36782e4100732f0cc9f19ba12"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f140095cd6eb79ad6d06396a3c3b1bd8d9c5072639e77e54de24b45f0e82ab26" => :big_sur
    sha256 "424d3eff3b11609ad4645c028b3806babf18d9457749486fceff2522e2dd703d" => :catalina
    sha256 "99d4980e850a91edc9e12749150151a0803aa0f2591a790f7236bc7031d1f8da" => :mojave
    sha256 "5ca8f58d406af543ec3833c190472cbefaa8fb614cd5f42cfc42392e3139283c" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
