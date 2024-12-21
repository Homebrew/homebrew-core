class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.147.0.tar.gz"
  sha256 "81263c1664bca6b8d2cfe2b1e3f643dca555951ecf185479e3071ec287897dc8"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "011d9b9facd23981a5140e2d0bce53f612b861db11454d6f0f0b78974f73921b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "011d9b9facd23981a5140e2d0bce53f612b861db11454d6f0f0b78974f73921b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "011d9b9facd23981a5140e2d0bce53f612b861db11454d6f0f0b78974f73921b"
    sha256 cellar: :any_skip_relocation, sonoma:        "357566125b9bf2c3ca135888b05807d9bb662f4778e3831968517727a4b5b920"
    sha256 cellar: :any_skip_relocation, ventura:       "0eaa015510933aff5c63f476d9f449d03c2b81873f34f7d7bd017f8dc53fa583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c775c977c230e578b2dbee9c6edac20f3cf594c93324219f0b99ade8ebb6506b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
