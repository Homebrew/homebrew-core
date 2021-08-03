class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.83",
    revision: "dd71ab37bf84e6d1bad906c4541f1fc9b4d0e7f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2d7f36327bdefe16ccae9ba0ab7360db3d24ecf902f2520ea6761db33b5067f"
    sha256 cellar: :any_skip_relocation, big_sur:       "1992fee6d02ea9a6eb38e5367605154561b0f76e26f91784310a4009e68563ac"
    sha256 cellar: :any_skip_relocation, catalina:      "038aaf48cb8ab51efe68abbd1e69c10ca4a1115d0fa1fb4d137ece67ba9cfa1c"
    sha256 cellar: :any_skip_relocation, mojave:        "b8a4119e8a8611438139d3e621c74afd3fd46a6d10cac50b254e759371d94ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdac19b476a917a8d72dd0264aa90733761fe23b768c68ee420796f1d2863134"
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
