class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.289",
      revision: "30012643540d9329169736e186f80e960773b505"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fbbbe81f51aea3b76952d2e24722e1f8c0bc4908401fb28f1abfdb26cb5a765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fbbbe81f51aea3b76952d2e24722e1f8c0bc4908401fb28f1abfdb26cb5a765"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fbbbe81f51aea3b76952d2e24722e1f8c0bc4908401fb28f1abfdb26cb5a765"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d2b50a9489a13be18916ceb1cda800935fbc6643081b9862b9a15491a330b95"
    sha256 cellar: :any_skip_relocation, ventura:       "9d2b50a9489a13be18916ceb1cda800935fbc6643081b9862b9a15491a330b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c707b91f4a9617c0448dc2301a9a569759b364eb6212cb12043ecb0814342e"
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
