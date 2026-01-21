class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "bff074f2c36fca619d2c45c69d0e979e45c3199809e64747e923762b44f37f8c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2754f871d08c4df4babb6a4df827ff1f5d83a813505416581423296987631a3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d961242d256d6b801745924c725045e621b5d1dd2765ed3d086bc088558766c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa8aa65f75e9d6a1fbecfe417b9975a142c67fe17b8a72709cd5a9dc05377110"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cbe7c12818ba31f9ec1818207c996650c4fafd4ed1ba017e4d1a79a3cf0b2f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbdcdcff73220c0177746e96f69abb9cad380d6de46ca93e361c269eb433937e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150efe899475e80269535d180049a0926338ff9c8e7573c2a3730b4f6dee3b56"
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
