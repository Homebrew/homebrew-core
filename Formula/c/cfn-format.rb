class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.4.tar.gz"
  sha256 "e9cb12dce01fd38c2a642fb5850db7ccc3c77d22e135449430279ac061c7a61e"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ea31f5dacfd18103193d3c485adb7c38775062c4d676847acfaec22121adf0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ea31f5dacfd18103193d3c485adb7c38775062c4d676847acfaec22121adf0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ea31f5dacfd18103193d3c485adb7c38775062c4d676847acfaec22121adf0f"
    sha256 cellar: :any_skip_relocation, ventura:        "444d1e5fb7b75fbb9e79b9fdcd453a182903eb1a393e42d0f3b4310b49e30413"
    sha256 cellar: :any_skip_relocation, monterey:       "444d1e5fb7b75fbb9e79b9fdcd453a182903eb1a393e42d0f3b4310b49e30413"
    sha256 cellar: :any_skip_relocation, big_sur:        "444d1e5fb7b75fbb9e79b9fdcd453a182903eb1a393e42d0f3b4310b49e30413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3308c85af43f29bd3bc584d4b268cd776c7a76ea1377fea13b1f813e44539931"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
