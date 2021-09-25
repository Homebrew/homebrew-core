class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.93",
      revision: "430c712659a9c2a8f7f39b9c42a888a41a414a2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "17194f6a8e54f98132c4b1d0609d42d0189f6a2a47894df2aab63e5ce1e57a06"
    sha256 cellar: :any_skip_relocation, big_sur:       "9e89483732e1972c2b697ad5adda9a75195b086f7080538d2617b8327b2591c9"
    sha256 cellar: :any_skip_relocation, catalina:      "08c4a8a36a6f042ed286098fde7b51b0ddc54b1424ea2efcf68ab299a3893449"
    sha256 cellar: :any_skip_relocation, mojave:        "ffb6b33247dadfde7f36dbff0d742461fd6880007002c841ee660070f976c288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3d6bd76837ca3e597612712cab7f4c86f281cb7ed3a1243b87b4853a6098c88"
  end

  depends_on "go" => :build

  def install
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
