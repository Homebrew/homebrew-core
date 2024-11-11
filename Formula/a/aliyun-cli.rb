class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.229",
      revision: "b0f19353fae180f2b61e762e92b57da002ab2a37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a182c6960afd20359342947f738fce17548ea0b5167980806812518ddd160930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a182c6960afd20359342947f738fce17548ea0b5167980806812518ddd160930"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a182c6960afd20359342947f738fce17548ea0b5167980806812518ddd160930"
    sha256 cellar: :any_skip_relocation, sonoma:        "f59bbfba87a79c09db774625e2c5a02acd771adf87f4e4ffccb4246bad136476"
    sha256 cellar: :any_skip_relocation, ventura:       "f59bbfba87a79c09db774625e2c5a02acd771adf87f4e4ffccb4246bad136476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ec204fef0991fa6556695497db459d58470aa3641ab2329517b275a4f04fd43"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
