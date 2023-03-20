class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.3.3.tar.gz"
  sha256 "230db11449b34043dc9e10a009134bd5dca240dc20a5d12710b98606f62559a7"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2665626a9c857808c7be349c3087f1e6b7ebdee30dfc7cc31f1496be7b6a6d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2665626a9c857808c7be349c3087f1e6b7ebdee30dfc7cc31f1496be7b6a6d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2665626a9c857808c7be349c3087f1e6b7ebdee30dfc7cc31f1496be7b6a6d9"
    sha256 cellar: :any_skip_relocation, ventura:        "9ac620ed5baf7e68acdec5b260d2d985c76134be5804451966678aa2e1210737"
    sha256 cellar: :any_skip_relocation, monterey:       "9ac620ed5baf7e68acdec5b260d2d985c76134be5804451966678aa2e1210737"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac620ed5baf7e68acdec5b260d2d985c76134be5804451966678aa2e1210737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6f4393be3ad63df8dc951c4e5877e3248e258460fe05a58157e7e32839c5fc"
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
