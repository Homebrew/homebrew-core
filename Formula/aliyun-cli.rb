class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.96",
      revision: "35b711e4d793210e533513a96ff1b1a014c1e443"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f0ccc33ac63a19ea74b3f4f33126fce2e3ca18b2a27c82875ee729e31d06c5b"
    sha256 cellar: :any_skip_relocation, big_sur:       "b16903d1164d39420bca409558c7060dd19d214b64714d235b19d3400309b4a6"
    sha256 cellar: :any_skip_relocation, catalina:      "aa9e911d274c67a5d21b430e9df0f1a2f0a77751ff208ab5e28f90b53d19170d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e22676203dc94429052fe76b9773452e4843c112c1e171f2ff9593a8b28e8c9"
  end

  depends_on "go" => :build

  def install
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
