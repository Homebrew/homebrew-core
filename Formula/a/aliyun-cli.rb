class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.180",
      revision: "03f50eb2fd7740f624de12539261f319f652af7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f46855d3b1d0d417a5faa904f7bbc8b03b72a4e55c972619d8514dc2a0ec94f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6b11ee574eb67095086492521b60afb1c996c7c720093f41d88b60c213feb12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7324b1c37fa18507025c128581e64dadf497028ddff2d8cb70a7bdf1e49b1cc"
    sha256 cellar: :any_skip_relocation, ventura:        "70856f17029798d9406d653d9a782990548687b642852f32e9d72d6b968cd947"
    sha256 cellar: :any_skip_relocation, monterey:       "1fe539ffafc529f2a2d6d8260cd6600028bd0ff971c70a483d97c27ff7211c90"
    sha256 cellar: :any_skip_relocation, big_sur:        "7765e800fc70681789a2a3f8fc667d054d540bcd5efe0aabba5539cd802aaef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ef3e4f8be778f53b6831e14415406cdbfb189ea50acb274fd51f581a2c91b01"
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
