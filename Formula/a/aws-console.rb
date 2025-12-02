class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "d0930fa6ba78b3941348b6949ee999c3de3ae87f328b7be3a8e40286cf2858bb"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68fc0a3b33b9ee90ea34333821ba7e5215b6859098e71dda5f8d983095bb95be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68fc0a3b33b9ee90ea34333821ba7e5215b6859098e71dda5f8d983095bb95be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68fc0a3b33b9ee90ea34333821ba7e5215b6859098e71dda5f8d983095bb95be"
    sha256 cellar: :any_skip_relocation, sonoma:        "a00d99757596cb31db6caf995f242c996887c3daebc454fca58286be5992eae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "939ea6f9ef977edea8a25ce381be0b254cd1775e2c6d262d32136561bf51de2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ac453d523c40a7e6174945c161fd780f70612db88a3ada8dcfce5ea5496d588"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/aws-console"

    generate_completions_from_executable(bin/"aws-console", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
