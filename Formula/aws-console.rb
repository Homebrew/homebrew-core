class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.1.2.tar.gz"
  sha256 "c5004a0d63e09949d2d89f7368dda12e9bf137cc6804b3eaa35a5b1f55320010"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09244900c8d421f8fbfbdc4fd522d05361fa5475e41dced4c192ba48f2ca7d4f"
    sha256 cellar: :any_skip_relocation, big_sur:       "da663b2695974e4c2d07c45c3656903c081301d4d484bef5714cb0f95ad7e9e1"
    sha256 cellar: :any_skip_relocation, catalina:      "7b5ba2731bd9e64960698f24323fb44afc1c25311946c90129b23b6c65f858cd"
    sha256 cellar: :any_skip_relocation, mojave:        "45ec4111bb96442156a645731f9e5c8cdc0f6896192d8c858bb55adb30b7e0ee"
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
