class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.119",
      revision: "8b3a542cca921d27c961dfde6cba7935bfe9e745"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "175d4cb3940bbac562d1e7c404182b4cf536bfd942d479332e161671ee9e11c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7200a742551a94679584b7ea413e78f810fed383d471778898318d6ae4db9d06"
    sha256 cellar: :any_skip_relocation, monterey:       "c885268866700e32b0ef9711530bc593d7cfcdfcac90afc9c7593ab4e40be24e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7532eda45f7df894002e7431f798c802a698cd6fce06568c71ad754c926c55cb"
    sha256 cellar: :any_skip_relocation, catalina:       "609d3b4be7a4611a0545a7fe9bd757cedd732716c25bc1ceff2462e206a01cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3819b350b6368276eface4159abb46ad134d13df8a15e7e878cccfc2050bb375"
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
