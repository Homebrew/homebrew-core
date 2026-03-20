class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "34b6ac569b1fb1df37d1320522f89779fe5b2722468916b2825419c3bb388d0f"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a264e5379297178a1d2000d7d89e25a39cf16100335bc3fd34cc7302a983520b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b7dcbd4cf10d51c3f767ade800a1aa46f9c8314b2e44c331451377c4a3a1d83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6c32425591001c8725ec9a809da6c80513b9172229033b48a6a2dde3a0aba7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6249bdd680a7f8be143a4529e8b51599762c7fbc703ea68cbf20cada6e561a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32b31b3d9caebf01fb5abcac05bd913bb356b2b217b87184d6976e3b41767e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fbb2e51c484a3b1a37ea1ec917598e5f34c498c3b3f456c5b473cb939b5dc8c"
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
