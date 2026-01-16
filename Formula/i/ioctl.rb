class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "e6502d310408d1f4ae8f215abb87b9d11a514a72f5c532175a065edb7f35dc78"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eedea6ac42d2f903ea355853426e9ade1d8e51c0c8c0970c7845478b7f5f19f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f5ac55590d519e716148a31c1fcc689d0058f7110777a8308ceb3f0910e64bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cb026c98207704d3131a50d93751f5eadbd74362b434946cc8007811711da1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "faff9560e695ba6b8ba05881ca90a93f6af05a152ff381059e99d70b0dacdabe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fb99ec75c335dbbfbbf5655859a108933af130beaa5b85e2cdfbd5b20538863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b950b02dac2ffc160332555416f3d779db3f02fc2eccd9e8c51a4a3aa998236c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
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
