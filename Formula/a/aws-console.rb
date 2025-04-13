class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "0f563154c49a6bc09164551463daee01cdbd5e2a9ff7bbc54854276d1608128e"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50ffbee824129a0ae63f19dc58772657f9b52d322a0cf84befb6907f9460937c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50ffbee824129a0ae63f19dc58772657f9b52d322a0cf84befb6907f9460937c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50ffbee824129a0ae63f19dc58772657f9b52d322a0cf84befb6907f9460937c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f05978a240080035d3ce63fccc42b1508001405920352e00c0c7789d819e711d"
    sha256 cellar: :any_skip_relocation, ventura:       "f05978a240080035d3ce63fccc42b1508001405920352e00c0c7789d819e711d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e19d4906f97547f93c1dde27c3bfe4b320973d095d01c7cb2d5929d617f55dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/aws-console"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
