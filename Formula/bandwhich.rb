class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.20.0.tar.gz"
  sha256 "4bbf05be32439049edd50bd1e4d5a2a95b0be8d36782e4100732f0cc9f19ba12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea3006254b7dd73866c339a6ae37663c41eae1eb89d1d4d61945acade47c9dc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8a4b58469686ecaaa23518da3bf9fa2ab3e78a4826b1d2331b6883e3770f6bd"
    sha256 cellar: :any_skip_relocation, monterey:       "3e1d94079bbe7ec292a13c2d012d410f503ca8b88888212fb94ea15d0c2c71f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f140095cd6eb79ad6d06396a3c3b1bd8d9c5072639e77e54de24b45f0e82ab26"
    sha256 cellar: :any_skip_relocation, catalina:       "424d3eff3b11609ad4645c028b3806babf18d9457749486fceff2522e2dd703d"
    sha256 cellar: :any_skip_relocation, mojave:         "99d4980e850a91edc9e12749150151a0803aa0f2591a790f7236bc7031d1f8da"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5ca8f58d406af543ec3833c190472cbefaa8fb614cd5f42cfc42392e3139283c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dfeb11084a21c529d74299c699089df7689f2b3d62439acea0bea1f0f9a3aa3"
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
