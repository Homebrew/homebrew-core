class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "ef6dc71698ad7d8caf1cc9d0d6a64aaf8bbc21d2449c0af804a2146c23950f91"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f64d19fd8dc9e7de45bf62a7a6046271fc1255a90df2e93bdd39080a974a3bf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8025de96c4e62ecfe9992dbefed90fca20be5c6cf7d0f2213cba95b33a49f3b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bd95df728a103d3f3b3db8eee955bd9c7a2a4fedaa83dba10d40a4918bc966d"
    sha256 cellar: :any_skip_relocation, sonoma:         "633ae8fec1387c795fceb4a90fd034d804283000188f8d3334d5ba055de67774"
    sha256 cellar: :any_skip_relocation, ventura:        "308d5a80b4697ed002c6f2083922c00554e966ce07b4d30fdffd428de179df89"
    sha256 cellar: :any_skip_relocation, monterey:       "71665159c5db0760a3b4f6ec6dfe171824d3322e62168af9eada74ddc57e3520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6b3b25b3de1655ec66e132ebbd7dda63cbf0facdc1cad4c5be87ca95f6141f9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/aws-console/main.go"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
