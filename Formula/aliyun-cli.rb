class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.112",
      revision: "69877d23c87873e22a1fb3ffe41ee83fa8e76dbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "316c118ba2055abaa7dfe5975b7d47a1cbcd740b3eb6aee5f3456b4c7c77c428"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9a825dd8f34522fccdf4620010a863f4280c88a36ebb4aacf2c2eeada25dd20"
    sha256 cellar: :any_skip_relocation, monterey:       "311ee3510b4bde8033b945825b1646d63207658ddad4c1c71d4811cbd4aa2c52"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7a48efa2e1e46be865b1e3d499ad243c353a92a118b254a913b80e5cd6aac45"
    sha256 cellar: :any_skip_relocation, catalina:       "f294db16cea0b7d2b1249801e0b3eb6efd3b1baaa1c975fc9861759e62d2bc23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1405beb39f51237fdd444b1dd066bf5fae7ef91bcced1d085d11f94469c496d5"
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
