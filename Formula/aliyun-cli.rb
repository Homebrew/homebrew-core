class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.136",
      revision: "1083a5b2b54a67d70d88a0599af606b658e1bd66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6edb75030869900d17f8d7f242b9f3af91c2aea0a40098ba294832ba50967c1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6671d2185d4c36bd80aa005b0c2aab2aabd5875a9782a47aaac5bdf5c0e7ae9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8268dff82c04ee6d966befebbbcee89f4a02fa51b6d6f99f8115059dcc31b47"
    sha256 cellar: :any_skip_relocation, ventura:        "1599122023e855c2298a53d3e259998e18576130e19da39f83928b3e45dddc54"
    sha256 cellar: :any_skip_relocation, monterey:       "88c6f26a205aafb9d71e73aa18731cb803e0db846f1d218442ed79e07df62a82"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9c4a05650292739c380e1555151a64bd9bb900fd07d4e2a73ddc7497f3e2300"
    sha256 cellar: :any_skip_relocation, catalina:       "95b638bbfdbb18f27308491acd985e079d317c86ed3d98f3732b658f45fe724d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83f9b8bda040239fc8ae0b7f2c0a617523eb65164a492a8623d905259c22d7d9"
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
