class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "46a398f91bc4dcb9b08e3d3f885b4b3dc12e8105611faf5c058641b60c81e19a"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "c518a0853bf048d8ce504fbe0613e16ba26c33544558357a51d70887831dd0c2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f56f2955e048d2d2af717ca817dc4a21ff876c409ad656a6d531ccc8f5fdb288"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "847fd05800182d81e95a10f73e84537e42746d4e6c87720f82615ce89c58cad3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35f24549194bc305a54ada0f098fa61aab5fdeb582c0d7c93e1b4386bb1dda24"
    sha256 cellar: :any,                 arm64_linux:       "ed84aa0d49fb9de93936fa74a7c12e1af016a6f8280b83ea07bd225a7a4b12c6"
    sha256 cellar: :any,                 x86_64_linux:      "78623993d29303c4f8807587fba16befe45f82ab15207e80d6973859ba8ba434"
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
