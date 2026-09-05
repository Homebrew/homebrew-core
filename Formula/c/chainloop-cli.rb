class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.108.4.tar.gz"
  sha256 "eb0af277c7428c2fa74a7816c3a543ae3329c9562bfc68e4b574e7355b5d6512"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0365c5c5df37848d8dc9a35b64e88788bd27215531770ae53a13672f7326f1e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0365c5c5df37848d8dc9a35b64e88788bd27215531770ae53a13672f7326f1e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0365c5c5df37848d8dc9a35b64e88788bd27215531770ae53a13672f7326f1e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5420e0c6fe5f5e2ef3c74253f6e4d5630ef2a1c68d4bada45fe333555f5f5b6e"
    sha256 cellar: :any,                 x86_64_linux:  "fa3b1af4e98b8b91e403c9f694a5e6b2d9d4ac835d92bacbda63ea3c5fe06985"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
