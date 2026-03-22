class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "61964a6f2ba2e528b0c8e9e2d8f579b544b763421a2e6023d9d9a8e38e491d35"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0918d37ef492358a173ce5146610c95b792f291c94e2c2827e5313362e565dba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849bf0291f979ac310d192180984eb1c6864ab593b219779b0d36f4ca41ba261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8425f691e5714352ff42250a188812fd5d70be06fec180f732609e19df213ada"
    sha256 cellar: :any_skip_relocation, sonoma:        "1126c5dfaacd4518f683bf698e4229545c4294af698ac7fb7b2f8b033aa5f2c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c405fcf456f6d3cf438ca9bfb4f8cd992f2e7851d216a4792b36e7fbf9b0fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47d5624fbbcecb2b54d93a4aceb93c9c58507953e73f639d577f5fe52a5dce6e"
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
