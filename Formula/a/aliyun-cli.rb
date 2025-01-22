class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.250",
      revision: "b9ab5d4128c61606c8ba741a450910b4eb1965b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d0b2a2fce08d08909ac682d7bf25609856f8841084cdaca6776f587a86deb12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d0b2a2fce08d08909ac682d7bf25609856f8841084cdaca6776f587a86deb12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d0b2a2fce08d08909ac682d7bf25609856f8841084cdaca6776f587a86deb12"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f9e1854fa5882d464c8fc2c30132bb3a0ce3365d85aa39397fef4d42c6557e5"
    sha256 cellar: :any_skip_relocation, ventura:       "5f9e1854fa5882d464c8fc2c30132bb3a0ce3365d85aa39397fef4d42c6557e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0237bda79f2fe46b39c3be9a806bb26e7a8bb82b36c172d971a8e42007ce6e02"
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
