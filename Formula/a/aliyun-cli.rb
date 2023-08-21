class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.177",
      revision: "2732cc1dd4ed9f5ceabdc8761c4c6cb23ae4cab6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c88a684404b1c1a6d6d1de2e4c5c5e8310dcefa5b1bd8f570fe4c588437c434"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfc36d24474cb80a101a9e09a09ec92dab9895ae743f3cf970752fd2ee75ee1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6afab26f123ae7ddf1a336130b529ec0aaab157f992c35f6d19fc9a52ece24e9"
    sha256 cellar: :any_skip_relocation, ventura:        "0669124b6c50e9ab203b9b7fc9a6f14eabac02f8155cec1dea3410b23fa44342"
    sha256 cellar: :any_skip_relocation, monterey:       "3ef9ecb06273ad28fa98db6f316e4052cc9495aa65141be3bf3933a171bc32cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e53c03d96ceec960bf2aadab40a90635481003d05e80a7921d9c0d8d178425b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95301c8f211b916e69cc7033d3bb5b3407d550bc8659b9652c4328ac8bd2432e"
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
