class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.280",
      revision: "6ad6a4b753ea50411f2beb39c81628f04608beaa"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "134451ee84b5df442b2d783d2ba13e99ea45ad964d1cf8d3efd481bb689a3058"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "134451ee84b5df442b2d783d2ba13e99ea45ad964d1cf8d3efd481bb689a3058"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "134451ee84b5df442b2d783d2ba13e99ea45ad964d1cf8d3efd481bb689a3058"
    sha256 cellar: :any_skip_relocation, sonoma:        "4486590dade748a7cf3ed027ba0bd4486f3f608e93a05b1a87400e498c63cdde"
    sha256 cellar: :any_skip_relocation, ventura:       "4486590dade748a7cf3ed027ba0bd4486f3f608e93a05b1a87400e498c63cdde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bfb2caf24947983bab6ead292bc2d2050ffb9e3790e374b160ec0b8609e566b"
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
