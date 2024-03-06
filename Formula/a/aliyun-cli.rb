class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.199",
      revision: "5faae09ac5306afba588d4f230855359a6b086e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b246e3ba72f89d21b5666a658a5dae942eb821cbfc2a3870d32a4ed3f478aecf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12d9f96dde2e2af61889a92eeedec417e391beafb29fd62ac3c31c1da5fbcb5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0467384687680ad4c6efde3824ffc07a93e2f6693d3023cb75708981f84ab78e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ec29412a09473ef7de33e9c9e4538469231214ed7877413f912ff69e33ca294"
    sha256 cellar: :any_skip_relocation, ventura:        "8b519e052339327b31e9505a7ae8649906e3bcb36edf5316384b3a8568a02b58"
    sha256 cellar: :any_skip_relocation, monterey:       "4f6567a8da6b0974095f1808afb7e21093ed380a9c4e98d50b63a548ce1b69d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe019e0701c3df62c71895f4eb3a251e8d6af5488bdaaa7cd5505480a60ac462"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
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
