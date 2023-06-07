class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.1.tar.gz"
  sha256 "9dd2062fc9c3bfc75759c116b6aabfd13694176f07bf9616c4c5acc5ff253eb4"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8adece2da8bad6d461a1989a8ab5aad48d636eaccd84f3e1fb459cd317e6578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8adece2da8bad6d461a1989a8ab5aad48d636eaccd84f3e1fb459cd317e6578"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8adece2da8bad6d461a1989a8ab5aad48d636eaccd84f3e1fb459cd317e6578"
    sha256 cellar: :any_skip_relocation, ventura:        "4d3e114871ac315453c164cd7fcbdc676484b52f8da729b3026c831879405b4d"
    sha256 cellar: :any_skip_relocation, monterey:       "4d3e114871ac315453c164cd7fcbdc676484b52f8da729b3026c831879405b4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d3e114871ac315453c164cd7fcbdc676484b52f8da729b3026c831879405b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6157c9d44671dbf0be91c83c8ac44de5d388d6c9cbcaa89d77437202087bbffb"
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
