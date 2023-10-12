class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.183",
      revision: "5eceb46dfdddddceaed5822e1464da302381ddce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb625afd423baacfd63db9f4babff0ba2fc5818d291db1d2582922ca32e8bc76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1726602b8c9249fc2f1c12f476e7b78e7f47324cd630f2684f4f4e4e37fa66b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0519266a2d0881b4e66f2f55ba29c71b38fd641a6f10630b1bda3df18ea44999"
    sha256 cellar: :any_skip_relocation, sonoma:         "d94cdae6457995a9e9140472058d37cdc06678ce3b81b1e43578073dbafe862e"
    sha256 cellar: :any_skip_relocation, ventura:        "84de6cfa2557a70aecfd657aa92fc9b8dc44bc351544e463afd3db666a7f9d0a"
    sha256 cellar: :any_skip_relocation, monterey:       "8f91e8de19352f471b29092364a4a37cc4057de5e135c910c7d2de73db8c55d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f00088200bfba7496f8853c35552bad225ce16cec647cc613d92f8c626d2f481"
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
