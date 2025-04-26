class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.271",
      revision: "8e60ec8a2f5a833724790fc48f88737316f24177"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fca936239911a45674faf0ae2df8387840be7d78176aaa1d41d00f3fb47c3f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fca936239911a45674faf0ae2df8387840be7d78176aaa1d41d00f3fb47c3f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fca936239911a45674faf0ae2df8387840be7d78176aaa1d41d00f3fb47c3f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "89d25ae0c9f5121f50685904fa4cbd2edd6d938b762605a159117c6de27048c1"
    sha256 cellar: :any_skip_relocation, ventura:       "89d25ae0c9f5121f50685904fa4cbd2edd6d938b762605a159117c6de27048c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5c9a18585971c775df3908b3221629a00c47a845bb02d51b03b38fd1147c49"
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
