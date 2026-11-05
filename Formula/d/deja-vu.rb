class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "c1b3f1a9b348c7d1dc4346b78005cdc9ff31b426f5cd0fbf98ef5345f899e1f5"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45816a581e272515d3cf53a26bbe0da6bb21077c9e29a8417f12dfa609bebbc0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "45816a581e272515d3cf53a26bbe0da6bb21077c9e29a8417f12dfa609bebbc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45816a581e272515d3cf53a26bbe0da6bb21077c9e29a8417f12dfa609bebbc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c0b11625c12d62c87adef390331b4d8763f963da9ab7f43d3eee59215fbbb4ec"
    sha256 cellar: :any,                 x86_64_linux:      "ff0d0456a5c5e572f0600345c0b02eed20d31250bf00fddba44187df95d8dbcb"
  end

  depends_on "go" => :build

  conflicts_with "deja", because: "both install `deja` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end
