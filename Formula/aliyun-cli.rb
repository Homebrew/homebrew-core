class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.108",
      revision: "1c81252d4a7d6ab668ba5ce18a002df7f931da10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc531f4b20a25a4ab448980bf8ba79c80c2d3b8feae256a4113cd4beb64a30a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dcbc95d51649a1dd7e4a9708c7adfc5a67ea5b04685a689a30f161a75e599c2"
    sha256 cellar: :any_skip_relocation, monterey:       "968c552fbf96033e811657658300791b570ecf944c908ed0b30008e54d28513c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d5acf587e1af39835904d3d7920218dfdf67b34e11693aadba868c7af994ff3"
    sha256 cellar: :any_skip_relocation, catalina:       "a3c601abe4a1cb48a2f5f238d1c63d907caec610a587788d8d70b78e2c5d4a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30fedc2f2a680a428ff689d81b69572468113b00e2155f553748af1b961abcb6"
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
