class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.147",
      revision: "b6c73713bd02fc1634e770ee300bae24c1588abf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76071e72a2160b46e49a0a3f6dcb42eebc44bf2424ee5dd4a8d0397cbc9c20c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf332dc27cdf343bd884082b7cfe7a6d699f7ad281ce0fe5c0d3c81dbc3f5e65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f8c818ba368b4548daf951db941b07d09f52c81133a288d97ba6795c220e2a5"
    sha256 cellar: :any_skip_relocation, ventura:        "b7d730db44c48d69b8db6abd5bbfe30e286d7e5c800a1609567771e451c9dbe8"
    sha256 cellar: :any_skip_relocation, monterey:       "fbad89d0d593744d7c36587e8c795f5970193aac1ae888b031677ecde576622f"
    sha256 cellar: :any_skip_relocation, big_sur:        "98217d5f9e3870de3003eb3ad213d32501b4955517697364e4143f8d722c9117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c72c8de0808cce3b0b1f41d5c836ed8a3d9c673d4b449443e2853ef55616dcee"
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
