class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "c90668829297568aca9ab43cf0af2957155ab44f224f9cd84173275d2a204c92"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a6b34637cf6be328432994ef42f7cfd07a4cf66f48ebe9fb4384f9174fba82f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6b34637cf6be328432994ef42f7cfd07a4cf66f48ebe9fb4384f9174fba82f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6b34637cf6be328432994ef42f7cfd07a4cf66f48ebe9fb4384f9174fba82f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9617a9ab3965f9026bf4eeb701c2845d66175b47881b3600b3650fee4a99a685"
    sha256 cellar: :any,                 x86_64_linux:      "01347cb1bddcdf0936c17877ca8f551d3059ca536fc9fab24341b23a2805d8f7"
  end

  depends_on "go" => :build

  resource "aliyun-openapi-meta" do
    url "https://github.com/aliyun/aliyun-openapi-meta/archive/9e2d20e1390a84f69e919ebfdc20c99b964fde1e.tar.gz"
    version "9e2d20e1390a84f69e919ebfdc20c99b964fde1e"
    sha256 "7d9d493baa26b0afabdc0e34e928853fc3b19a5b78ca751c7c14ad9b458c326e"

    livecheck do
      url "https://api.github.com/repos/aliyun/aliyun-cli/contents/aliyun-openapi-meta?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    (buildpath/"aliyun-openapi-meta").install resource("aliyun-openapi-meta")
    system "go", "generate", "./bundledmeta"

    ldflags = "-X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "-tags", "aliyun_cli_packed_meta", "./main"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "Quick Start:", help_out
    assert_match "aliyun ecs DescribeRegions", help_out

    dry_run_out = shell_output("#{bin}/aliyun ecs DescribeRegions --cli-dry-run --region cn-hangzhou")
    assert_match "Endpoint: ecs-cn-hangzhou.aliyuncs.com", dry_run_out
    assert_match "Action:   DescribeRegions", dry_run_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
