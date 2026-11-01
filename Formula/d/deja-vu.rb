class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "a98332394134c1bdd1078001a3e6737014c9113e720f88f02400c5a48edf911a"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "de5dbe3e27b2b7591c9b98563e8d718a08faf4c1a3262f9f888fe2495bcbe5cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de5dbe3e27b2b7591c9b98563e8d718a08faf4c1a3262f9f888fe2495bcbe5cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de5dbe3e27b2b7591c9b98563e8d718a08faf4c1a3262f9f888fe2495bcbe5cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b0e4c4dd15e94dcfae47f7d708595ce43a4e9a5a0ae87648ed122ac1ef74599"
    sha256 cellar: :any,                 x86_64_linux:      "e51059c01564af4406e7439bc61c7cafe75ac79f11b7754cfcef6dc74736ffff"
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
