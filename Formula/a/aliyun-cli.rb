class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.200",
      revision: "2ce2723f14ef05876a389d61fdd125f4becb5a05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5b11f9f1147a150c20f87bdd15b9cc20907c197f30e3818ae873622310479fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bfcfe7c3307f0c4df852c07c2f2986c197eeec0e4e9de4ac5c7c80380fdfbe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08c4f6981577b6d51c896b78bac43e161251cd2d8a6e36563d329ac591ff838a"
    sha256 cellar: :any_skip_relocation, sonoma:         "50c2688cad4c66ec894b40fe695459ee647ba1af95e3ef85bb7178e0f8266de3"
    sha256 cellar: :any_skip_relocation, ventura:        "79b69d229470bce618b8240650228f1da9a52046c517dc378f7e4f3719a8fc77"
    sha256 cellar: :any_skip_relocation, monterey:       "3ad9289d1750d28d93fbc7472b16accc406ee0f8546954218b50ba20a1c437ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2c80e6f80c9717addfba2ae422db64a9ad58512d897b9b81e8cbdbb8c89b3f6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
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
