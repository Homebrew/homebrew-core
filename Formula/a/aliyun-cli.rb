class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.293",
      revision: "fa05a1a0c17e8a0829064fe48ee7cc330872e7d5"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c53f1435472c2899f4215f3decb698f0332c8a67a873d09ca0441bb5f3c98616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c53f1435472c2899f4215f3decb698f0332c8a67a873d09ca0441bb5f3c98616"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c53f1435472c2899f4215f3decb698f0332c8a67a873d09ca0441bb5f3c98616"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e50e1880a6ed6789cd4dfedf2e75b8bec685889ce6463fb443c797736bc4559"
    sha256 cellar: :any_skip_relocation, ventura:       "4e50e1880a6ed6789cd4dfedf2e75b8bec685889ce6463fb443c797736bc4559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b41c981a21dddf9a349e8f666769ac97162cbc22cad76a31d0c740d7418babe4"
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
