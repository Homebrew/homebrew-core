class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.123",
      revision: "aecf1f73dcb5911cfd6821cb02c601745782bb39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdadee17889b38cab9ddb741ae21c647605f10ee68a1725d5dfe829e080aac72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a098ea78ac71e0bbfbeeeb9b32c9239420f96fcff8c9666063729995112d99a"
    sha256 cellar: :any_skip_relocation, monterey:       "d2f0da66d5ca047a0682ff6e9df747e918b95431fa5c4bbde618218cbbc08570"
    sha256 cellar: :any_skip_relocation, big_sur:        "91bb26d2173f708f046ca490718f5941b31ce4a1be234a213e0e79cfa6405b79"
    sha256 cellar: :any_skip_relocation, catalina:       "34d9f33b6544703fccda071e8a8e7cd29e4eae043a2ce9a44064ceba6ab18fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b047561fe6b1914d18b67ed93830923d3bac8355b52039351d5f18202b44658d"
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
