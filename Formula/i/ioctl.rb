class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "a49ce532d3b6e7041c8a636991766e4babe5d43c77f20dbce93f136a289f6b7e"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83bd38d0e5a579c1ebd497083b513c9baf763ea3d866c3350c1275e195c09529"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ebccd46d8e88820a20e36a5d6082fba477362241742a44af49e6c5116a969d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c74adbf1d64c56b134b6bab9ae84cec66cb0c576806297d9b7e0c2e3b4c22d8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a2927f7b63abca16082557b9daabf41832fad490d90872b989aacd2e165a8f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "531600fcccb7e8c8be9d281bd259762d66571109ae5fbc07a91898884194c699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fee6acb62f0fcf259beb939662c4b5c1f72ebf17fee7177fa74a2303c3e21ff"
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
