class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.10",
      revision: "1146457cd90f3cb685282e0deeac268088cf3244"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a33afce8da74d1f24d845c80eb27fdd39089953d0731e348170b507e2d90e5ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a33afce8da74d1f24d845c80eb27fdd39089953d0731e348170b507e2d90e5ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a33afce8da74d1f24d845c80eb27fdd39089953d0731e348170b507e2d90e5ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "24647166cfe5d30a132ac58e492d1d523e888ad386604a2083e76ead9d6e7d17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c9d5e530d92d1b7e2823d1d694e26597543bc8d36e355353a57b46023598914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b18034fd7a3d81cf4020bdccff3230bdf64b87337fea2ac8d5809dc81e429842"
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
