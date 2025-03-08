class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.256",
      revision: "b3482906df5319e31a17427d43a55e504e7b2a2b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8be526b5109cc7e3b07805ee8216d244c1c4945f66b328c41311db44f76197b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8be526b5109cc7e3b07805ee8216d244c1c4945f66b328c41311db44f76197b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8be526b5109cc7e3b07805ee8216d244c1c4945f66b328c41311db44f76197b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d735ae508211cb055aa57b0d68ee3ad3c26d163251f16f4737cbacffddb89a09"
    sha256 cellar: :any_skip_relocation, ventura:       "d735ae508211cb055aa57b0d68ee3ad3c26d163251f16f4737cbacffddb89a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cae5877b4d3546a48d00b7c036eeaa94fad354ffc3506c5275b64f5921c98e54"
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
