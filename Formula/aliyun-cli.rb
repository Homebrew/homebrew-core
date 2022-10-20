class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.131",
      revision: "c5d05abf410064a29f152e34453988fc466a517d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aff88930817f9fb3bdc7897411213bec0e912f637a80d0846f975ab7a5692d63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "861cbabd828e0e84730d4afea80e9c9df7a275148673a97e42ca8e2b35a77dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "e43bae00eb84bae217786ac1f49f6bab92c01d6b2316cfd869df92636b3c5d1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b94b6b644bfedb347b9927503196dc10faaf3897814dea9e961e5fb19fd9d88"
    sha256 cellar: :any_skip_relocation, catalina:       "f13db6cf26620952cb6f2821980a61b9eaf3b72f3c82b4e9d08736051525b6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beab88153d372a1c4ff6790300fadbf4d4bd09eebfa0ceffce9a4d6cf2ba42b4"
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
