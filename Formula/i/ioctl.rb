class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "323f9c8c7e9ed023fca04ae41397907655e4661d161162498c48df24ed69bd9b"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e95603285cabcb4a2b4526553100e93a4c7b363ec30500eadece0eb7f9134346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "725e954c3283b52f3a6870801cc90d1b3065c007bd65a94d59daa76589825fa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cef717bdd9ca4bbe385f81203a2213206f8588526a461d231a7595e7d9f68c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe1f956a143d7d68c518f17be03f74bf6e55cf3ad305972e2c9fad28fb3be0fd"
    sha256 cellar: :any,                 arm64_linux:   "fa5be8a25f9a7dec7ff7a2825a539489498caf2b2caad93ddc19aed1ddea92c5"
    sha256 cellar: :any,                 x86_64_linux:  "6bb773c6fcf9ef0bf224259bf7ce30bbe4ae6633b0b4972344586d9cf2f59cf7"
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
