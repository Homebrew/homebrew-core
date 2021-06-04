class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.79",
    revision: "c6e361d1fc04bfbdff7ad1f72e79415105d59629"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c17d7a96930dece0ac1d872892e8d15c7accf91ebf7583af67da1aef7ab4d68"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ab90ba4b574d419ccb0e77a591d3adc5a481479deaabb63bc6324617fd82d37"
    sha256 cellar: :any_skip_relocation, catalina:      "648ebb20e21afd38692644019e3242a53dc95c5619859996373a427c74b8fb0c"
    sha256 cellar: :any_skip_relocation, mojave:        "119500c356f5a392b177b848cf6a15243e00ec082fac47203221962ce632fdd0"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "metas"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"),
                          "-o", bin/"aliyun", "main/main.go"
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
