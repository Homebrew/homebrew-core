class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.272",
      revision: "9b12013d828f86ff32e0a1939acc856f8fd47134"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c87397f63a497b05367d667986f53fdc1a904315b8f63b40696233e257e501a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c87397f63a497b05367d667986f53fdc1a904315b8f63b40696233e257e501a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c87397f63a497b05367d667986f53fdc1a904315b8f63b40696233e257e501a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c42e933e7104feb9f125b51cb942ffb1bfe4ebb11755007493acc26c8bf71aa"
    sha256 cellar: :any_skip_relocation, ventura:       "6c42e933e7104feb9f125b51cb942ffb1bfe4ebb11755007493acc26c8bf71aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f3138275cab8a4042385d44c41c01aa163cfbd390b892bdb4b3a238348e624"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
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
