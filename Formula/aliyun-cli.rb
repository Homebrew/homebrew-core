class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.78",
    revision: "f4723bb6b4db0f0c9c2566d14888b816eb34dad9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7f3635795dd2e643e8c97bedf6ef5716c7cd24941a911fb57ecfc6ec8aca9c07"
    sha256 cellar: :any_skip_relocation, big_sur:       "a8a8448f722437bd1e18b7a801487a4a7ae227814c9a792b991590fc884a3450"
    sha256 cellar: :any_skip_relocation, catalina:      "ec670df27b1e618d7aa61315cd73083cf05e12f05596d44b54abf1e2ad683fad"
    sha256 cellar: :any_skip_relocation, mojave:        "71894337060fdfc0a5ff4dcebdd1ef29f064c748618d3f9b50aeacaf3eb974a5"
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
