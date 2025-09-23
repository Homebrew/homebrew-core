class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.301",
      revision: "5f2066ec686900d01e778a35031c7e8ad29a7ef0"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e99ab8797e2c015a5a8faf048febaae7134547931f54a5f30b469ebd35e42dee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e99ab8797e2c015a5a8faf048febaae7134547931f54a5f30b469ebd35e42dee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e99ab8797e2c015a5a8faf048febaae7134547931f54a5f30b469ebd35e42dee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e99ab8797e2c015a5a8faf048febaae7134547931f54a5f30b469ebd35e42dee"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c89fe4f531bb4f3e22bb72ecb5cb7acbaa39451088958c2a7c3426385aab12d"
    sha256 cellar: :any_skip_relocation, ventura:       "2c89fe4f531bb4f3e22bb72ecb5cb7acbaa39451088958c2a7c3426385aab12d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13982d05f3022994fa1216f5910a2b7ddf34482a9a8c620d645d1e487fc8f9fb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
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
