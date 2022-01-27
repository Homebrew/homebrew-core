class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.107",
      revision: "0188e444ca12ac74ad04698d19223fe7d2aff9e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99b219b75d4a625b8805f30809f746d1a6b2f0c33761da4d6737a0437b0615be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc66843238d8de4a549b06690822f30450299fa661e45bd80c47365cf3d5088e"
    sha256 cellar: :any_skip_relocation, monterey:       "abc2ae7e89e91300bf0cf98c57f89c8b913eedecd02cb841929d30fe9d4ccd44"
    sha256 cellar: :any_skip_relocation, big_sur:        "af8a38c01a51076c3c7cf5657e4dda0e5c109e560407ccdb227b86b0766f6735"
    sha256 cellar: :any_skip_relocation, catalina:       "9c8044d96922a0137c5f6c38fe46c692e3499c2319312f46df7a9b0ab46ce8d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8087d54a3cc2c0d95c4747897522ca2649c1beee2f32d9703e8663b7674df3f7"
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
