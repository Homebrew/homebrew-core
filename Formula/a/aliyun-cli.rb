class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.1.7",
      revision: "4348fa2032b6f172e296fc25c21c6b065fc7da95"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c34f08b7ee8d8a658a377c0f3d8c6c12643cfb80e66732137b18e66a8ad461b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34f08b7ee8d8a658a377c0f3d8c6c12643cfb80e66732137b18e66a8ad461b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c34f08b7ee8d8a658a377c0f3d8c6c12643cfb80e66732137b18e66a8ad461b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "24838d2b2194d9974613a37087750d88d52ae51983ab4e7def5519489f0aaa49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77a883ef1dc42e01ab66bb6a0face7577dd04a5f94f254ffeff9828bc76371ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b74c75e48f3470e01467ccaa9b73683a5810f6a4e4a9cb578d9426dd91804c3"
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
