class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.134",
      revision: "ab80acade335fe191270fc41b46ef77f02c1b9ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce87db5c8458eace4b1d94cf30595a76b54dd19370ef2674e1597124350e8c6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e0337d573f3034653b6acc306e83f92dc0f3d42d9fc62e006ee1775a2bd499"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38bf02c8a743e32883a31a722ef27287a6dca9125beb75e56caf24435ddfbc89"
    sha256 cellar: :any_skip_relocation, monterey:       "05bf1b0fd37c813006c10711d8923070bc701e37aff91711ceebb79ad54bc225"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff07ac4c8d4d2b2a03e916df2892f855521c804776fed0a917a169df765c8f5c"
    sha256 cellar: :any_skip_relocation, catalina:       "bd64aec7143ac0d11e6f7e5884b56191efa7e333d7ca888c0f1466d68266f6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5e4b8a0c39a09f18b92343c33264cacc8864dc5f7b98918ee2d3d1719804639"
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
