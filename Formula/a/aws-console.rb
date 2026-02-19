class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "a49d6409eec1549c9990c5352b1fcf0f3276df7f1f10cf7686493c8be262840f"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d3e1f67db37e75fb9a1e235ef374391ba4ef617eb66fc8b9d4d7ef42f799b0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d3e1f67db37e75fb9a1e235ef374391ba4ef617eb66fc8b9d4d7ef42f799b0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3e1f67db37e75fb9a1e235ef374391ba4ef617eb66fc8b9d4d7ef42f799b0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "171c8394feec2ceb590f5c92e7a871a461756f0edbea6581013f85065e48b7b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "563a99de5e589be7e627bf12937e37cd949789a40290b6a13da97a98615a66a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b03b6059cc2de5a06553356a3b88b8d6e554395825ca925f923e59d5c4440b4"
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
