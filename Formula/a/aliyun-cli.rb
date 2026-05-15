class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.14",
      revision: "4c8ac3d0cd168823c91090386c4617d5035100ab"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a07d3ed38d714e5ffb278e3a2f3ad91a2e04d5402fcd19a60735c323912d077"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a07d3ed38d714e5ffb278e3a2f3ad91a2e04d5402fcd19a60735c323912d077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a07d3ed38d714e5ffb278e3a2f3ad91a2e04d5402fcd19a60735c323912d077"
    sha256 cellar: :any_skip_relocation, sonoma:        "93fe4656f9bb7d2f1f5cb9c7ba7bae17ba9e6180a42c8812f90649b29a1637eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61b9019ea81a96e7ab2a761c8153b57119d91485466e60bf391c0539092141c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b672ec63d326cf3ed4115ed7e79b021fe11016e1b7f218f8c2b4e1fadd186b66"
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
