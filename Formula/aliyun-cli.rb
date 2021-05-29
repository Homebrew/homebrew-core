class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.77",
    revision: "bc902e1400b30e618646115d8901e5ded9dfcc23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64e17dd2817a84b0a69da4f62dab1b79063e1504dd003876d17f1f891bac5913"
    sha256 cellar: :any_skip_relocation, big_sur:       "f1b824dc1f97ef05a8e85c893d9da21aeb39010ed6fa1e3a405a1df1a682a6f9"
    sha256 cellar: :any_skip_relocation, catalina:      "2d56c32a94af62f898e4f090dc15c118dda0ee008c670697966806557796b02f"
    sha256 cellar: :any_skip_relocation, mojave:        "cd67fe1ef523a84e9f854c24f417d8471a7095dd9a962fb2ea91755cb4f36905"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "metas"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"),
                          "-o", bin/"aliyun", "main/main.go"
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
