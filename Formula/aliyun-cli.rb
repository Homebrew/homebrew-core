class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.76",
    revision: "668f4091735add11f301ca9451972b505197519e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81ef256729f675903319bc1ede1cd3bdfbb8ecf4504b3f3148d97261b0b9a91a"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f185ebfc48d136c205ec6e64a203e08350483f144b95022b0de6a604cf95ac5"
    sha256 cellar: :any_skip_relocation, catalina:      "baf80be7cf5c611e6291224862b38850c7fe8bbb663d615e1baae29d00d3a410"
    sha256 cellar: :any_skip_relocation, mojave:        "a4a8e154b91e66333c824aa99966e7a1775f44f3d78503d4d9eb35a7233daec6"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "metas"
    system "go", "build", *std_go_args(ldflags: "-X github.com/aliyun/aliyun-cli/cli.Version=#{version}"),
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
