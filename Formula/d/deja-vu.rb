class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "8efe4293648070b7f92b9ecc093cf4f347dbb283e1b939c3274e8835ba1fc3d9"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    manifest_sha256 "8356a1d7eb27045c3960bd6c2a55c275b4a931127f733a5b03dd1e683dedc4c6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfbfd1c4abcc4bdf751f729358dbbf27442ac2eb647642d239fce455bb672e81"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cfbfd1c4abcc4bdf751f729358dbbf27442ac2eb647642d239fce455bb672e81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cfbfd1c4abcc4bdf751f729358dbbf27442ac2eb647642d239fce455bb672e81"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0693bddeffa2fc4df5b221251badb6c23b5426057e4868caf13648ccda4731e0"
    sha256 cellar: :any,                 x86_64_linux:      "6f1d3d1cbffc9308b30c182c95e3743b1dc5611be38594bdf12c9c2f479aa752"
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
