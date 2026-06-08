class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.22",
      revision: "8f10435f94bc51e3e6ac36171208fceeae0df7cf"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb9886c4634d5bbd0e81de68f6a87eb889dd0bb7ce97f0efa3b0ab0c097d38cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb9886c4634d5bbd0e81de68f6a87eb889dd0bb7ce97f0efa3b0ab0c097d38cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb9886c4634d5bbd0e81de68f6a87eb889dd0bb7ce97f0efa3b0ab0c097d38cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bfba87ba9afb35561d96272eb6e1248363a420b3445ee437bd77275f5b9d1e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18b7ddea47ab8763d5e98fc88b8538bc972456eb752d1da8df4768f0e583135e"
    sha256 cellar: :any,                 x86_64_linux:  "ead64bfcdbb7cd78b841cd9166067ccfdea9457165097eefdc7137a590be858c"
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
