class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.81.0.tar.gz"
  sha256 "6f192e8d758ff94c3301ad67367dac859b7c62adaf47b4dc9c5b55c5763f1815"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fc2fe6bcb2d9f69dcc42963cd0c8f9799db715781f5fc4fedf5d5ec698cf8c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a186238442e5e369f49596774db51adf3188db03cb618cd87bf27a5f1a10e6de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e85dd4fe3e0b5ab196625656976e69b0f0d115ff65e81b9ecbe230c4d2f211b"
    sha256 cellar: :any_skip_relocation, sonoma:        "09423d77fb5f64fcddb344daa09c162b126d375341e8686bb6339b64b42f34a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b79bf2e0de8260b3e0b8f71d3455c9a52c21d36863970f44e893ad0a29d75e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bef81a5750e0a448d395c7cfc3d2886643f11fd89ee776b468bcf36f606c789"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end
