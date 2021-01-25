class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.1.1.tar.gz"
  sha256 "5faf25a87a6fc0fde19edcf2fe6f26c81990da91d13fbf3858b1eb33711b0ebd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0558c07748aa61fada24326aa0e8f06a5699f66cf1b47be9606e7a042a2e36fe" => :big_sur
    sha256 "14a391d0c3305d0de61ccdf4b4744d4f9d1beaf825e29742c8fa3c0fa95b18b9" => :arm64_big_sur
    sha256 "2aa67b0cb10ae529bd38baa85813a66f8463d9b13c0e9848c604aeae213ec0a5" => :catalina
    sha256 "7c4b25aff982c5e21dd8e0f10fbdd5107a936c0466de4c68e13ee6f23d9d4e31" => :mojave
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
