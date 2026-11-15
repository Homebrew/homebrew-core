class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "89857d24d39b949f2b92111b8a2a2735201f975136dcca272bcd6c13decc9a25"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36272818918f1e72ca2285edb5466a9f8f73af7516fa078b0b3c2acfd7299a26"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36272818918f1e72ca2285edb5466a9f8f73af7516fa078b0b3c2acfd7299a26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36272818918f1e72ca2285edb5466a9f8f73af7516fa078b0b3c2acfd7299a26"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2428c48ee97a9061381edc78e691ee22b77d86add2c414048cbc6b59d4e04405"
    sha256 cellar: :any,                 x86_64_linux:      "7303f007abc107dc72e995e47ed87ba4f9f7e5928b729e1d54b1721c7831b6dc"
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
