class Fargatecli < Formula
  desc "CLI for AWS Fargate"
  homepage "https://github.com/awslabs/fargatecli"
  url "https://github.com/awslabs/fargatecli/archive/0.3.2.tar.gz"
  sha256 "f457745c74859c3ab19abc0695530fde97c1932b47458706c835b3ff79c6eba8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c35cbba29b8f2bd5bb92841a2356fa300622a9c42defca0c3f6886e93c3f5ef9" => :big_sur
    sha256 "ba7b19d6b21be020f27b1fc3b65e41b3c58467d92e289399abecb48cad82b9c9" => :arm64_big_sur
    sha256 "4cf90341de4a444842414de2364ae5ed51283008dfd99739cde4fcd00583f50a" => :catalina
    sha256 "193a1ca57966d54bc0ebaaa5b28397448f2ecc0276d6f69b4adc20acd8324553" => :mojave
    sha256 "c5b6d73103fdab97321d13426271177f03bb1240db637f8d252678e376e7f129" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/fargatecli task list", 1)
    assert_match "Your AWS credentials could not be found", output
  end
end
