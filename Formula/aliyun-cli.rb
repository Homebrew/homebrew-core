class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.152",
      revision: "bef5249562531911a29143ce7ad272453627617e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0826fa0ada4e89881b18e1ef713f58f071775939cdfd0fa8225e41aaa4e6a077"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0826fa0ada4e89881b18e1ef713f58f071775939cdfd0fa8225e41aaa4e6a077"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0826fa0ada4e89881b18e1ef713f58f071775939cdfd0fa8225e41aaa4e6a077"
    sha256 cellar: :any_skip_relocation, ventura:        "e64573096c4407e08e047ec08fc2162d4b82ea453377a75f7b1fcd5cef5f358b"
    sha256 cellar: :any_skip_relocation, monterey:       "e64573096c4407e08e047ec08fc2162d4b82ea453377a75f7b1fcd5cef5f358b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e64573096c4407e08e047ec08fc2162d4b82ea453377a75f7b1fcd5cef5f358b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59cff1d777766f5eb260f0b0d4710297597823ea63c1bac24faea7df3ec1e5cc"
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
