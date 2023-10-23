class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "c29365570082ee15f598c1a0af46541e42e77651f13e0ed5adabb67f8cb80ff7"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e271c4c9c08a9bad91ef3d192fb3fb0193fdf3d2c1d8ccea849a2ec6a5ba8d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b4d96f2b281cd114c2f933735e1ae3f5fb27fdf56e412d37d3d265b9cc4349a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d764524ec4a216e4f6e2a151d5ed4dc2b10268b58b205cfc497629b7bc462c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7d75220e712e04ed694c320733da799ac1e2f67c41d6a3988107e7e34bce550"
    sha256 cellar: :any_skip_relocation, sonoma:         "3684b5906d39eafedd0cc9d7e957b2c2c29df7662d03a372828d16401f887f79"
    sha256 cellar: :any_skip_relocation, ventura:        "9cdde1c0512eb1bdfc9673191f2e8d79f7e727868d22522d011e63e1b8e66bfe"
    sha256 cellar: :any_skip_relocation, monterey:       "2d2a6b94e1f58693d32fe5bff7c3753be028b17cdd5601c2512c4e29317ee773"
    sha256 cellar: :any_skip_relocation, big_sur:        "d221c765b4bc6b3d02182b13d84157418fad0fb7c134f3c819ba804500142428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "589fa8eea2809da48c5834085db2e3e1fb7045ec990a9055ecde7df1bdd26c1e"
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
