class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.84",
    revision: "905afc1b6c04fd4f7cdaa007ab92a0363553e6c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9b10ddedef0fd5efdb0aa71b3719047d9d7f1bfd8b52a5cc7d4fc7f77acc65d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ce1849d7f8ae350a3201047dabd4df4ae51bdc86291f052da8923dccc13c8b7"
    sha256 cellar: :any_skip_relocation, catalina:      "cf3f8ed7e298d929499928a6b06f8133988b4512db90a88c262f87ae36146926"
    sha256 cellar: :any_skip_relocation, mojave:        "60e41f1d1d25fd318db843c90ddcaa371e6443d08a3fb7785b72def72b041041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc5147d698e91d8566c337afcf5313b49fdd8d78b0ec39a679e11c5c709cd4bd"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "metas"
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
