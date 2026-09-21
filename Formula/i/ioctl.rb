class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "60cd30a0c3180f3d5d6afc2d0895f980176ec6f135acd27b5bbc8f414a6e42b4"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "64976c941ec4d9324f7d4f29eb5647d13ada52062f129b052382cbf8d57bca0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d997b5a2247227022af1864278bff298458c234fbfe26b41520e8c219e6a32ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "378b89935f512f800fa179fe34f80dd4d752736b44598743ab3ba6a5f85bca01"
    sha256 cellar: :any,                 arm64_linux:       "d1690afb597c53331ce2a6d5874eec17c6397d800f30c1ff6a111315b606b9c3"
    sha256 cellar: :any,                 x86_64_linux:      "091b7ef211465033babb625bf6dd3846fcb05677e85582285f07d2bee8d2fbc4"
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
