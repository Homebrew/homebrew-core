class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.750.tar.gz"
  sha256 "46c8a6cb3699a99dff1b305ae175bc59efa1def3fce2173bc511bd2622520ac8"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "3ecde76a02fdbf1621be43b5dcdfd9a8d24fb037318b98dc27872c48c1783d33"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6efbd2230a639a03735af33e7315bd2c7703bb531d07f911bb6fe90e27d5461a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f557b6646285a242cd58b7791e01d60ef27ec00f803404da800a97f4fd59e9ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0d7680e9f9b034d99cc3890bcbacf4533e7e2e6a6cd91aaf1ca005a5d94ecbe"
    sha256 cellar: :any,                 arm64_linux:       "34c554fd995a3df1767903571e2c1f14ee669717a98ece598e6a23eaa69aa4b8"
    sha256 cellar: :any,                 x86_64_linux:      "e3d367b77608a4efd70063447d8b1d2151817326cc3fe1179b2aded69624f2a1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
