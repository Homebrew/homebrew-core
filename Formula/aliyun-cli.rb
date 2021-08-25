class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.88",
    revision: "017637745ad7ae86c5422f1f9e2e6d78771bd080"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "009a58a705375672f47cbc0b5c26daa9faa6ea1f357d123a7663928815fc7644"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a4e6c8c11da7178bb492035e91dcfe858b023c8d9e67bfbbffbb61773a7dd78"
    sha256 cellar: :any_skip_relocation, catalina:      "f459ec6a75c8e371e0f77d463e246afe6095b0d8a44d00b43406662e63b2a4b9"
    sha256 cellar: :any_skip_relocation, mojave:        "8787c2937c3ed1daa3e63701c43921432beddb191001ad61dd0e2fba0069e82e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be82c1aced7090d2f59348c5ccad62427ceb71a2ce62a32aa2bc2d8ebc62ba65"
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
