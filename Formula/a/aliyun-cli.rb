class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.305",
      revision: "93d237fa311f4cf1310a2c58ac0eed1bc22f0152"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35b1463dbc3c48cc2fdddb305e8cab40f80ec5975a08819334ecc2f796127e05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35b1463dbc3c48cc2fdddb305e8cab40f80ec5975a08819334ecc2f796127e05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35b1463dbc3c48cc2fdddb305e8cab40f80ec5975a08819334ecc2f796127e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "a22751a9980e5be2e3e66f6a4caa2497be9e02f823cdabf50452adec270db836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08170413de84408fd0432e53d872bfb8ea224567adc87be6481bed09c29e8003"
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
