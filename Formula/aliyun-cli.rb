class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.148",
      revision: "3366b816d258edfb89cfbc7f4d8a0acc73500a80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92136da5fd43f914cca73094d9bd0e7a370a74a6955b7afb9e71730c6f95e339"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04ec7541d8d6b8e4b0ae8116a4536ad367a53268d6aac1613b2a915a7a824a1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fb02dc3d8a05e96df26911a5359621236fd1e5743d01fee7b5cae3dd26d103f"
    sha256 cellar: :any_skip_relocation, ventura:        "0864a2cfef14b03430ae426504a0fcfa0d6cfd3c2ddb22f825658a5607395f9c"
    sha256 cellar: :any_skip_relocation, monterey:       "719eaba297dbfd1b04c3b11cfa1201a819f4d12ef040dd53e0e1dceb6c63766f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eed09b79ac693397d0d594261163264ae29ef2f86d387edf05a98182ee7823f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2df1eb15fc7f04f093f7d9dea93ab45932cc78b3d24b3868257ee99cb5cc5da"
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
