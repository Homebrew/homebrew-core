class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.1.5",
      revision: "ac31563d8c7914adb269de605eb07db4b5748309"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d48ec70f5e132dbcbc3cec2da17623c33430727c32b6cc9c04ffbab3a0566a5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d48ec70f5e132dbcbc3cec2da17623c33430727c32b6cc9c04ffbab3a0566a5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d48ec70f5e132dbcbc3cec2da17623c33430727c32b6cc9c04ffbab3a0566a5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a38ad3c41789db304bf7bccdad648ff83c5b1587cbc02df1ebc2906a23e52aac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32c66dff75d9f1356ca5394e09ade5be695d093384c7618113c20d4a07e86314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2ed611e5c367663bff864ba42e3babf9d23406c835c5c74eb77ccaa217c01d"
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
