class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.106",
      revision: "523bc5ea791d34fcf77a7487f6d261bf83b8954d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8439057b4de5ec3c10eb768e22c1189959d083a51be5ab72752a3cfb6ee142e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c86fabcbdb7c85e7df31ff89089a437695ea06253bbcf763a7ba2241cd0927eb"
    sha256 cellar: :any_skip_relocation, monterey:       "f92c65614b20ff680e5be28461f73444921dcf180f3f0643b8ee41ee79afea27"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e1b215d895a2373268fe946e198c1521bb94923a30527f1ad433376b7fe5f51"
    sha256 cellar: :any_skip_relocation, catalina:       "05d23a8c197c4ece351ca86504164e61606a2c6dcb9dbb9eb3d92418ace7a522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0e57fb13ad07a4a51022b0907136162c984b334d271f6beff22e67bf0a04109"
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
