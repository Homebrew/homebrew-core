class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.111",
      revision: "7e290f756a5bc6033192f1409a2fd837e0e68b80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4cdde302b8a02ea9d605fccab05fac300c62855d3d90836b3fed68f402d3dcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6eebce5a1d731f1b3414ee783cf02bae3cd539a44f525964b81f18d067718092"
    sha256 cellar: :any_skip_relocation, monterey:       "0415e5c18514b4d57b01d010018edd1dc812455faa7fe6700c71f79b31b9ea0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfa690d969d334b97c8f64781f751aa7dad2c7eb24f1f1ce3a060e3912b48dfa"
    sha256 cellar: :any_skip_relocation, catalina:       "5208f9a472f5de3d380c2e9cfa56744e469acd028812a40ee537f1d6c1864f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5462153e7975114878fcb90221baa8ffee600ec7828896a2e8caf7e5f1c62b9a"
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
