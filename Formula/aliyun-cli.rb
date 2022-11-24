class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.137",
      revision: "cbacadd14ca3848dad0d449dcbaeefd425b8c03b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "646de5c39909a367efd383d88009573906eec053b474824875770e2cf1b3d3d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6f9d48d14ec81eb84ed1ae45f6b28b11c2d6a28d2c12cf10e87fdede049a6aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1192f53b26e15d67522214c125283ce3a0855715e95d4d796ee0c4171be8927a"
    sha256 cellar: :any_skip_relocation, ventura:        "a24035035f5eb9c86799d7dccb4f65558e9d5292f84d1c5dafa172f718168528"
    sha256 cellar: :any_skip_relocation, monterey:       "d9d74d6d7e825f588d013690bd45b5541ed7f6dd62b5e5cd00d44c726814eccb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7a74f7e7cbe36b637fc83e7cb3370b7f1673705f8a1fe249c657b2d2f9ac25d"
    sha256 cellar: :any_skip_relocation, catalina:       "fb2a1fc043ab2cdd798cff496cd0ba8d15646fc9dc080b85e1d35505dba30c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e230924bbfd97bb0fd51849e5137694062ceb2f1c90671919026a1e8196cab3b"
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
