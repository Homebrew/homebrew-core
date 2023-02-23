class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.150",
      revision: "224f3a2cad9193bfc0ba2317da62e30719350f63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd942f58c27273e26f5ad4b368595ab8636e4eb9d6d129629294a60ee004ce24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f378803d21d7552b224d8f198f862c976916387d2a42692c09501c4bf15faa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3638c567fa247d061e074e2b373a5ed79efb12c849fe5efd73f55b0891af3674"
    sha256 cellar: :any_skip_relocation, ventura:        "decaf96fa76ca115b9fc245e0b84a3e895438013a3e2b6848df7220871b9f988"
    sha256 cellar: :any_skip_relocation, monterey:       "767b0aa08ef2e4466acc48d2a13f2286c022cb5108bd54ef0dd751ee7e66608f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9754a4aa6c4e89a5b461121256ca65dd6c5cdc590a0171dd1a27cc15ce207e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22aa70d408993ae250cd9e39e0d2298be124d017463b71c69d3db706f7119c0f"
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
