class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.131",
      revision: "c5d05abf410064a29f152e34453988fc466a517d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6997f509bdc3f67c51fcbba5a4e8d458e71fb82a2560267e8ca608b8a694b9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91944ce0636c0eda660abb972fd58b08ff93e5b2753a6da1ce99ff5ed0f3570c"
    sha256 cellar: :any_skip_relocation, monterey:       "5b86ee546e1daaec7893d174e9291eac7853576d81eaa429a6e6c1351532a737"
    sha256 cellar: :any_skip_relocation, big_sur:        "537b466495311b108d160049b9a937394edaa57484253600797636b86d7da050"
    sha256 cellar: :any_skip_relocation, catalina:       "a7ad3d65a395fce7e3032f2c9293e1b5fb0e89c2c67bce8b3af7bc06263f733a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8a49046a832e6707428981b3e7574522169c847ab7af46021a9354141491b45"
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
