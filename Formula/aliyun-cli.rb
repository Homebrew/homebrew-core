class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.165",
      revision: "67ab4ebd377d95a01eaeeaf578601a06c5b84dbd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81ed160288b1c00452e1349448981356cea3ded3f3c813eb87276a7bd17668ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81ed160288b1c00452e1349448981356cea3ded3f3c813eb87276a7bd17668ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81ed160288b1c00452e1349448981356cea3ded3f3c813eb87276a7bd17668ad"
    sha256 cellar: :any_skip_relocation, ventura:        "314091736ccbc525f6d875a64bb738b52cebfa91d84c2316c5859ab32f352423"
    sha256 cellar: :any_skip_relocation, monterey:       "314091736ccbc525f6d875a64bb738b52cebfa91d84c2316c5859ab32f352423"
    sha256 cellar: :any_skip_relocation, big_sur:        "314091736ccbc525f6d875a64bb738b52cebfa91d84c2316c5859ab32f352423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "324564159fb8976596939f70a266c3a82a6b69709619d23870747d8a7b04f83e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
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
