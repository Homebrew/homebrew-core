class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.202",
      revision: "bf0dece6bece4f47fd38986aacefdff03643cb52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4afb54be7e63d7f0c8e8a6fba369549afa2c9249746fd9ce68422c3315bebca1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d92bafcb4860899e1ded993b5300333dd7b63b9fd432650b884b369fefc163d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97a0289fe9f7251a69759c7307af7fe756a31d0c6202201cb3386016be9db38a"
    sha256 cellar: :any_skip_relocation, sonoma:         "25eba4ba676bef66e2f7b4aaec90ea6356a9e157eca1e064fce2d44585b400ff"
    sha256 cellar: :any_skip_relocation, ventura:        "892d5fef7879e124f735a8ff7f3173a9a3972e07db6f00d04c18582899469063"
    sha256 cellar: :any_skip_relocation, monterey:       "1223c8cec8b78c87cc3802fa0ce1350bd5eb0606c18bf17d26ed810edf26315f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62ee2726c1f0e238f0e18aae8e9227137951cc739d128dedd74a712fd4204f6f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
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
