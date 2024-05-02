class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.204",
      revision: "57470075406dc10f1c95486c218521d8f43d12c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03e3f60d6e36fc801686d5559a2fd839734dd31bf47bc7eaea25899e0f09208b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad79e840e754adebb04618646feac2cc4487d893734f5c43c945ffb35fed8022"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "364b512b7e2b8caef3c616e61f3f6ac2a50d9a1d086c340f6ba45608b0088108"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ed5ab3e3610e08ec10cfe2b642dbd890166baffb8bb2a3d6729f572620e0bb6"
    sha256 cellar: :any_skip_relocation, ventura:        "48a072ea9793857e1ac09495fbd54b9fab38b70b8d88cdaaf7c084dcfe1e9e48"
    sha256 cellar: :any_skip_relocation, monterey:       "faf08154b5e6dba64077fbbad56fc4718bfc475baae9302dd6d33643a3ebd871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc9e91e4a487a2584615c696c9ebfc50943391c9bbdfecaeedf9ef9486218ea"
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
