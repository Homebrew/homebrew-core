class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.2",
      revision: "1d1e735352b322b43f4dc6ce79f0b09795a1b29c"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70064059bec7612b6c8dafface21fe06cc09843cfe3159b10cc3b4f35d134e06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70064059bec7612b6c8dafface21fe06cc09843cfe3159b10cc3b4f35d134e06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70064059bec7612b6c8dafface21fe06cc09843cfe3159b10cc3b4f35d134e06"
    sha256 cellar: :any_skip_relocation, sonoma:        "c68024f6d5d990e48b3f13f7276f1961a0b35fe4da0998c3dd5848e66d78b015"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d740597e88769cc6f48ee358dfd4fc94eb91e965bc7c45726622426b12790e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d22cd00d0a2ae1ec6e0fd24c71bfaa1c405ef825bd9d50ee6a974f31588bd655"
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
