class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "47ff89511181b9e79abc1a9491d551417b66a515f32c09bd5b278aeba3a03937"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "881f32b603f275da051f5441bbbbbe8306a58cb2bc83ef857cf409ca1a6714bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "989fd94856bd9204671a1d79f06fd1c9e49e156a0127238a5fd3461f2e2ff5a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a4bfd9cf657aa3b66d537a5a9f2106337c64e5daa3b1d771bf2f408588a0f1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba908b96227b33fb6d3c47711bbe872fcf2818be0d09bb368c24352885dd4c78"
    sha256 cellar: :any_skip_relocation, ventura:        "b7301d6f5a720c7fa320d6ab87a86e065a66947353a847eb6aacce952674b139"
    sha256 cellar: :any_skip_relocation, monterey:       "f9c6d1dffd1764dca717aea82c485eedd5192bfbb65e65edee6b4d615a0f97f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "469025ef14a972667e0a3f92d03b1576971ba08f3e6e3bd0c677b0a7e514ac3f"
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
