class Fargatecli < Formula
  desc "CLI for AWS Fargate"
  homepage "https://github.com/awslabs/fargatecli"
  url "https://github.com/awslabs/fargatecli/archive/0.3.2.tar.gz"
  sha256 "f457745c74859c3ab19abc0695530fde97c1932b47458706c835b3ff79c6eba8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "183015f15c85815aff732a2361baa4866507b6a98a92267f518e1b8dfc543859"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba7b19d6b21be020f27b1fc3b65e41b3c58467d92e289399abecb48cad82b9c9"
    sha256 cellar: :any_skip_relocation, monterey:       "c344a892d3d21c9499db679db25f6927f3c713d4afffd9f8a9bd42bcaf111435"
    sha256 cellar: :any_skip_relocation, big_sur:        "c35cbba29b8f2bd5bb92841a2356fa300622a9c42defca0c3f6886e93c3f5ef9"
    sha256 cellar: :any_skip_relocation, catalina:       "4cf90341de4a444842414de2364ae5ed51283008dfd99739cde4fcd00583f50a"
    sha256 cellar: :any_skip_relocation, mojave:         "193a1ca57966d54bc0ebaaa5b28397448f2ecc0276d6f69b4adc20acd8324553"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c5b6d73103fdab97321d13426271177f03bb1240db637f8d252678e376e7f129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6878839aa708ebabc144e18b0b77f0d1e7754eeaad8634741338fa2c921c6de0"
  end

  deprecate! date: "2022-03-16", because: :unsupported

  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/fargatecli task list", 1)
    assert_match "Your AWS credentials could not be found", output
  end
end
