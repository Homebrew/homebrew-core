class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.1.1.tar.gz"
  sha256 "5faf25a87a6fc0fde19edcf2fe6f26c81990da91d13fbf3858b1eb33711b0ebd"
  license "Apache-2.0"

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
