class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.149",
      revision: "866b69f06cce3854c4a8cd5b0a119c8774be007f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac47b12c30dd5bb2c1c86ff8f66f14e6aebfcd9d3679533f0dab7f833cd72505"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb02771de40b2fae130699e43dc7a69e719acb85686ca89d0a354aeacf79fb89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3429b0d377a0eea71718b09d0192d5ce5fc92697f2eb0a857c12560c57b078f5"
    sha256 cellar: :any_skip_relocation, ventura:        "74403d9494ee401961e066fbe28151709470d303e25455cd8d40f075b96eba28"
    sha256 cellar: :any_skip_relocation, monterey:       "5f4e81aa71d31e60c5b498f9495438d81406e76bfcfd2b2db7cc9189ba3ece67"
    sha256 cellar: :any_skip_relocation, big_sur:        "77135cc7056b47e4e5c03c69323401555034d65b1a25c3d8f2d0d8d0dbadaa34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96a726df02e36b8a4d1bc42f0b7c50fb696333022acfba768b5f2512787f6279"
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
