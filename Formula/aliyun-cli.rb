class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.103",
      revision: "ce2fded4607e5aca33a4c77e0afd90aee1093f23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "049da6331796342c7f8046a2ad3d9bdc4c5b6ef11573c886f9946bafd9a1a226"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c931bdbdd83f4d6b64b2707cf69a4b2d75cff6f724d0f75049ea57f26d103879"
    sha256 cellar: :any_skip_relocation, monterey:       "6e37c0d5944bc2ccae93a653f4cca4df9bd26d365cedd0675394e5cfacbacb0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "35cad003a5eb8cd6ea5a96cc8b19387640823688feea8c63bebce48d8fcd2bc7"
    sha256 cellar: :any_skip_relocation, catalina:       "23ea4f615abe71d8ab106a44aa9558a7863394d5ac22762228d054d0bc91fcac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82ab73bff3d16effb2515bc057eaea2eee70b25c32aafe64bc3fd4912123062c"
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
