class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "59b3f60572ef108e5f651560c53be9d1ab509cbfcdc40a26cc1e1dd0cd3ce634"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b31e867962346f475375217d6574a690ee62bc60a5088690a584cdb7cb79ec1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b68dbcf75864668c4c3d4999cd3326b8c9c4b7ca46ac9f57c2faa9dfc0437e89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9696eb97c98b2f6822f392783f753e3d2bf2155c752d11564e6813253e3493c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "eee050791dd063d1938e5f6af4780d160e0d34ab8a0ae13dd5d61d1310d96a6a"
    sha256 cellar: :any_skip_relocation, ventura:        "ecb26f43537b0b55597fdb4ad1c6bbb6db61556c0838dfe8e0eebc2879f643bc"
    sha256 cellar: :any_skip_relocation, monterey:       "aa7c6de51dac8362150a0cc87bec42e6601043b1ea7e56b34cdf2e2265889154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c181ed30280ab637cd8b1aa8ebce1ff8b411436c591d0af47de65f89d960f0d"
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
