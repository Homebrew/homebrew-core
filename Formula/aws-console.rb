class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.2.tar.gz"
  sha256 "fead74b5e0663ca598887d44f0c681e9a2501eccc8f7f1d816041c1b2531deb8"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "427060cff493c7e8d9580443b64c7233f088f46e37f914d506eec29dee007909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "427060cff493c7e8d9580443b64c7233f088f46e37f914d506eec29dee007909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "427060cff493c7e8d9580443b64c7233f088f46e37f914d506eec29dee007909"
    sha256 cellar: :any_skip_relocation, ventura:        "8dc10767966305bd598675699f598a1b74f7710a54ae6bb36a10f1d6d7990bde"
    sha256 cellar: :any_skip_relocation, monterey:       "8dc10767966305bd598675699f598a1b74f7710a54ae6bb36a10f1d6d7990bde"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dc10767966305bd598675699f598a1b74f7710a54ae6bb36a10f1d6d7990bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8817020a6acaeccc06870e85302a79f9c43bafb93891a4796f9193d18c2b0d21"
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
