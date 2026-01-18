class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.6",
      revision: "1c05fda061a527a4f097297e913ab39aaa0990da"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02bb6df7ac856558e1c69fcc1103bc0ab7eb8ea339bfaf132f75b3468e119d5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02bb6df7ac856558e1c69fcc1103bc0ab7eb8ea339bfaf132f75b3468e119d5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02bb6df7ac856558e1c69fcc1103bc0ab7eb8ea339bfaf132f75b3468e119d5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "69ae0222992bbfa401653ad8745f50a3e59860fa4bee400ba22e5faa7d9b89ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85c69c2b44009bf3357d56e2a054a1bbd8effddb1bb0595f64cb1aff1065d45b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "211e26a6a4952b2c7b9f1c93716174b111a50e18ba1d1ac38c674179cca95c68"
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
