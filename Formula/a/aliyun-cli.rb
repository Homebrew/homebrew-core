class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.224",
      revision: "158a70e275f060b151184efc7882af3d9acd8c95"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e72d877dd4afb527cf52455b16ed3a386dce18d2aa301f9cc5f29dad86106317"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e72d877dd4afb527cf52455b16ed3a386dce18d2aa301f9cc5f29dad86106317"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e72d877dd4afb527cf52455b16ed3a386dce18d2aa301f9cc5f29dad86106317"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d88d697964b086623c4998e0b41c900868e090925ed6f2f03a148fa45e1c32c"
    sha256 cellar: :any_skip_relocation, ventura:       "7d88d697964b086623c4998e0b41c900868e090925ed6f2f03a148fa45e1c32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d8c23eff4bf266c40107893f0483f160beb8ed52485ac0dabeb62c746099d04"
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
