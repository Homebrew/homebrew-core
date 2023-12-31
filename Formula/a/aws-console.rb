class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "8d3390658664a60b503c85ebf23d13c07b0defdbd29933f564aca03ba986e3b6"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df822af2220a5355164ad0c3ca9cf1ecedbe611fc98ec126ba76554cdf315b40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dd39b778ed3c3671f898f3cf66c16bb507f12a049848541cab0d2245e22e0be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dc051adc043162599fb01d6e8447e45f405b8df0832a1d217b6a1331ffe5b01"
    sha256 cellar: :any_skip_relocation, sonoma:         "9abfc6c0de5e24b0ac04f768edec106160e697f6f9343ca4d7eced0f392bd5b3"
    sha256 cellar: :any_skip_relocation, ventura:        "85012a889973c93b0da2718d73a9e89b7bb0796029fb93209f708af7943edc9d"
    sha256 cellar: :any_skip_relocation, monterey:       "0e60112722f7c3463ff3d4600c478a98d368a2ab89338e9af085dd674cebefc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93c91707541467d16d7d9e0de9a496129a6cf929ba7d9bef7bf7df8a6b723a1d"
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
