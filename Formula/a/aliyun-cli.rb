class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "3fb6e79f14e4e871c519c05945085ff7dca9839688ac2bded5a088e1e818bb92"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e10bfeb227bd6d74d6b3eac83bc841b4fc67318a2469faefbb2e27c60f71ae49"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e10bfeb227bd6d74d6b3eac83bc841b4fc67318a2469faefbb2e27c60f71ae49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e10bfeb227bd6d74d6b3eac83bc841b4fc67318a2469faefbb2e27c60f71ae49"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f7b9f7a29303a8c75c6e548a15228d25db96cbba154266472784235541305a2a"
    sha256 cellar: :any,                 x86_64_linux:      "396e71241c62d0beea0c6955165bbfd547e95b9331fbb15215cf92ff6cc8319f"
  end

  depends_on "go" => :build

  resource "aliyun-openapi-meta" do
    url "https://github.com/aliyun/aliyun-openapi-meta/archive/1876f2666a44341c9f757b2f31682958a7a9eab8.tar.gz"
    version "1876f2666a44341c9f757b2f31682958a7a9eab8"
    sha256 "2d863c1f07933feb2641f34eae165cccbdbba02129ece94cc995f3aed5d277ba"

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
