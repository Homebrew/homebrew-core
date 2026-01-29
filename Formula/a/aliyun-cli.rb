class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.9",
      revision: "5de5222567331056aeffbf46f55605fa8d5212ca"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "093f3564f50b419220c2255f260474a11b2f1039049e0ad26b42e9498df184bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "093f3564f50b419220c2255f260474a11b2f1039049e0ad26b42e9498df184bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "093f3564f50b419220c2255f260474a11b2f1039049e0ad26b42e9498df184bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "03159aa1f5c476ce4dd4dfe611249823dcdf091fbcdff57d1c83f95557b21c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b4b54abe524504802f158e74cbe23978c0c47ef42611b0f5a6f638657b17ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e95d90c4eab582295e1fb13e1491efb8cad17321a7689b4da08c1b4f4af4f87"
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
