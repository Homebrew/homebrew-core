class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.3.tar.gz"
  sha256 "f56190d874985e0bcea79cc1ca233846173164d000f0c4f1d0051f2e26fee20b"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d2fb3068e56b9af49e4c00557bc21382183b86b4650fedf2ddeb70b26d83240"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d2fb3068e56b9af49e4c00557bc21382183b86b4650fedf2ddeb70b26d83240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d2fb3068e56b9af49e4c00557bc21382183b86b4650fedf2ddeb70b26d83240"
    sha256 cellar: :any_skip_relocation, sonoma:        "6102d31d5fee5dd6341f1b3d511bcdb1034fbccb0b7c0a1881c12c5f537b64e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeb8dab79eaa20337c7da7de5336dc7c7bb0084e7c939141efdcbea33e231e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87841f67c0c336b6bcd299b59efbef9545bddc435780653795a9e0bf144638e0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/aws-console"

    generate_completions_from_executable(bin/"aws-console", shell_parameter_format: :cobra)
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
