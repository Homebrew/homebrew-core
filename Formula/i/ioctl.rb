class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "c66a4673ebd3bbf4a4163dee26aefa36369c49e0b98e4ea900a99806e44e787d"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2fcf41ca1155b91fd0f8373e5e2e85e347555bf7a4885f92c7234ba0d221bf44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60fd09018c4786174137125eb9b8f872b6061615c25711c2a108ee60b50132de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f31b129127cbff9f44c081b7dd918c81b71364eaf212c910652f70c79c5de9ae"
    sha256 cellar: :any,                 arm64_linux:       "762b98ea81b0f5dfdccc6020823b270b6abbd41c7a5d6a54ef14c810cf231b1f"
    sha256 cellar: :any,                 x86_64_linux:      "717777474cb9f58e534a13e1deeb05ce5970725c80992080c47199add7c57401"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageVersion=#{version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageCommitID=#{tap.user}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GitStatus=clean
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GoVersion=#{Formula["go"].version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "nosilkworm"), "./tools/ioctl"

    generate_completions_from_executable(bin/"ioctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ioctl version")

    output = shell_output("#{bin}/ioctl config set endpoint api.iotex.one:443")
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
