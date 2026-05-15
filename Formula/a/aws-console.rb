class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.4.tar.gz"
  sha256 "1387dd8e17160a51e8c99fc6654107bcb39dc94a137338c13e4ade30a344d3ef"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "872fec19319083eb2b6286dc049dd352b6df61369cd073ed56a059e90eccd6f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "872fec19319083eb2b6286dc049dd352b6df61369cd073ed56a059e90eccd6f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "872fec19319083eb2b6286dc049dd352b6df61369cd073ed56a059e90eccd6f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "956810bf81fb976de92e1c9d5fe7c2718b27208138d7b410fdd66e10c1f6e497"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c66dc436e48b3ba01a87fd7ebab6630d55731442ee25a135d3313a21912a4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "893f775b8331703fa7e40f540e39bc066be95dc7790b6a5e5abd44b085600417"
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
