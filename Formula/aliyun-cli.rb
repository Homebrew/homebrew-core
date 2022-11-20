class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.135",
      revision: "24d44a75773022c16cd54068f15a37a8385cc5ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6168896ca913094e2d2788c0ee4bc83c0a8df5c56d758e18d810d0c0023e0a07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30f57b8ed4cfbf75a49f8070acfb81bbd990bba55ba3a284573d95f906d25957"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd9cbffbe1877a3d6dbd8e42e8d82f12aabee912704b6dd039f7513a26880b84"
    sha256 cellar: :any_skip_relocation, ventura:        "4998e9d90a441932a78fae851526c6eb3e3bc40be107e10639d93b912133a9e9"
    sha256 cellar: :any_skip_relocation, monterey:       "28a68ed93974ad80a4a2c7ec2903588811156c6895b14be24b070cfa8bb90aa8"
    sha256 cellar: :any_skip_relocation, big_sur:        "af9934e53b3546ab5fe8408417b7a5bc3bfa8371c6b03e41f3387f50a27bf47c"
    sha256 cellar: :any_skip_relocation, catalina:       "faddf9350322183b15f23ef2f3c488b3ea1cc4f0b80ce27e503d54347071cbe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "462e38f5f3fede80f53e8f5fa8247b821d576ecc6da5f5df6e889ded08a07d99"
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
