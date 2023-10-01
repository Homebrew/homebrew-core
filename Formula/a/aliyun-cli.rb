class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.181",
      revision: "9c3a577a2fdbbc48bcf46c059d649f89938d1d47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1477a8a92cc069ba5c1d8be90ec0fa115e3767d538816d1e9b8c1d0630092ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c69dc397105b0f1413d116c475a2720537bfd2f979674666921d634760050342"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e79d613e26e7cffe8be32d543202993371b17f1afad25f102fa887b772c2b5d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "110841a24cf848dfe64135ade816e9501aafca1fed8e110c059cec82c6db5ac7"
    sha256 cellar: :any_skip_relocation, sonoma:         "14696c4dd85429ac06ea29086cae3ac62a3999474e76bbe23fb17ed563eef210"
    sha256 cellar: :any_skip_relocation, ventura:        "807e0f0bedfee4a852cfee4e32d05ea1d5b7bbe98c5ee361f16fc1ba15cf7783"
    sha256 cellar: :any_skip_relocation, monterey:       "6e356beb7fa3d5e8e3b67c3683a8dd607598d8e59dc3882685845bf92f743ab9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c316182d86251a575bfc724bc2656b0ad1ab999311d16304b025de967b1de98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "363b59e5137b208c3a472a1e810f6e7fbbc6c342f9982e4174466829cdd55009"
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
