class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.3.2.tar.gz"
  sha256 "db9c0c72d2e6a5e0d0114b9c6e5a33f32ad4aad9e80c9dadacab2b7e9c2de35f"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0a3f7325843123b4ddf16be62b854dd06001e1656725f33631418450250e7af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "606d9b64171f347a2e2f9fc2b98b2323ac01db45159cb401f22b10604c0a910a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8389a21995f448a3033faefd98b40276d5885987997fc2d36c68944384f713f2"
    sha256 cellar: :any_skip_relocation, ventura:        "ee9639527f1b842e88bcf3525a31f44fcc2bc102d6393aa00554697c7a1c6ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "8e14431314e92505bcf153f845c605af791ecfc924ccddeaebe2a19b35ee486b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd7e6905694a0afdf06539408ca05be5c0d9ef00dbb3876640b2ad0ac235f7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c9b1db591375812e5960ec61bf79edd83a8e01611269a5c38da893655339632"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/aws-console/main.go"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "could not establish AWS credentials; please run 'aws configure' or choose a profile", output
  end
end
