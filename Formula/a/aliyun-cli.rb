class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.219",
      revision: "667e5c6f8f9da09423738280d3c535a499b77bbd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7dbb6db84238cc5c6063f85aae224da866ae62176aa23fe4086cf7e83c864379"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9293eac12024d5ecd3780596cd7f0cd0b3edb5e848e6ed7e45657a9f06d5bebb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ba589e769fe20030eef5139855e3d5e4d784682a873044d686bd3b4940e60f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d28f94f65c9f9f90fdc35217786f04251aba6e0d1d0037f8c180e8d20aca389"
    sha256 cellar: :any_skip_relocation, ventura:        "1e0849797b6019a88780657a86d5dac0b1ef9bd1dbfb669e76b2f5c3a2077826"
    sha256 cellar: :any_skip_relocation, monterey:       "564d66e7c729ab5611cb6a8ce7460ee2aaf5035fa9603488f376a1ace2cecc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6c17ba79cc71f7e9cde1dd70e162df5a784e16d88d21d664d1ead418a74cbc1"
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
