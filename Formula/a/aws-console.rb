class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "820724a0cde1066345982b81b42921af86906966d0e51151ed24a6e3c1f08740"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "624c2e9a156e183546ca612af7e293d44ba60e29267e8b288c85defc3bb6a505"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "624c2e9a156e183546ca612af7e293d44ba60e29267e8b288c85defc3bb6a505"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "624c2e9a156e183546ca612af7e293d44ba60e29267e8b288c85defc3bb6a505"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f4b7f1b4ae0bbfd1eba137db3e02f61b582f0abac18a8354f96f5bcd2c52d47"
    sha256 cellar: :any_skip_relocation, ventura:       "0f4b7f1b4ae0bbfd1eba137db3e02f61b582f0abac18a8354f96f5bcd2c52d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f2fc520617b2f25edbfa951b4aa501796e845683688a8d0127e3f0be438415d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/aws-console"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
