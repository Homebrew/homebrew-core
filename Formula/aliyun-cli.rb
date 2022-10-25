class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.133",
      revision: "58f7ce56c3b9255ca7c4820598254981019ca8d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d3f7d0eccf9d23efa632e53630c93ca9c063f8d294091ddea8c12a63ec69415"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "484e546aadfd647816a777c6333d3ffeeb64b3de20ad608536cc4a7733991fdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00cfe7572f1d38d638e6c2b7707b2cb7cc78830267fa80c90cffc6f0611d4c40"
    sha256 cellar: :any_skip_relocation, monterey:       "f47136e957a1d45f3d8c4d13b3abcd266b357d2bda342fa5caed0bb369ce2b75"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e7f6c7afcc34784980ccf462dbb8b5c46131c451f5922461db1fe85b774f1f1"
    sha256 cellar: :any_skip_relocation, catalina:       "0f791e66ac8cc47a8173d7e053991639c773b35f4fe6e944ef5f3d4f54626bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49fe06256d3d96228bb6d6709ca7d21595735c1190f826df375b9308a7b8fb71"
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
