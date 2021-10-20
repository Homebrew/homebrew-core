class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.94",
      revision: "48a0ebf6c0ff0444590c15aa83d328103b634170"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db4a02899742d90ee720f33a98e34b14c16ff389c4db516c654b00fa350f966a"
    sha256 cellar: :any_skip_relocation, big_sur:       "3dd3caf8c4799bb084fcacc590dbd30d78e68df2b57d721c915a877213e2df57"
    sha256 cellar: :any_skip_relocation, catalina:      "18d3297e1bf2bd268e3cb3785820f72060f24ecb9712e33e2ffd507d14a4a4cc"
    sha256 cellar: :any_skip_relocation, mojave:        "5872133329e07c5c8f30417c7268b6c80e910d83a6c1e990dcbd8409220f67de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992d0d82e9ff498338484b9a6eacbc00c79919c1c7c2f1b197ee14993f078784"
  end

  depends_on "go" => :build

  def install
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
