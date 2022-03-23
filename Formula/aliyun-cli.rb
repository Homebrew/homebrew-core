class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.113",
      revision: "d6b8dfc440dfbec70d5d69402452a95d88e60789"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "007a573bf8c91e3c1a1cbedf4d9e60c09e0120a6aa5d96275a8d41e7a0e8c5be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "527d733ba50e347800f3ca80a7de28dfeea575ad6f5be52772961fae1e8f5cec"
    sha256 cellar: :any_skip_relocation, monterey:       "498acb436773ace06cbc0f8839decc900740b7286ab69722ca84cb8d7797d7a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1faa43fedcc664307df3e6f3d38c002c1610382f546df62f32bd789b2483fd16"
    sha256 cellar: :any_skip_relocation, catalina:       "185ac9dee1004765128c8e4c2bd3653269b6ec9b0141da36781169e1a78a072f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "775cdf79e4643bf61b09cde90057a056d3432d8cc20f1fcc6754abb137f830cf"
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
