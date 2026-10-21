class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "a48889624c1d63f078ea8c1d49cd0f22cc0d1e9b15031af72c9eac0a45b3b2a4"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6110ef01991d0cf15e2b4954cfe9c0d25754c3b968753049daba22279fbb6348"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6110ef01991d0cf15e2b4954cfe9c0d25754c3b968753049daba22279fbb6348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6110ef01991d0cf15e2b4954cfe9c0d25754c3b968753049daba22279fbb6348"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7771bfe5ede2dc6a6e48977aa77f0cc5de318b8d9a3cc6d32fda168dd66a7c6"
    sha256 cellar: :any,                 x86_64_linux:      "2063f0e1b266cb76bcf78c5614faf2238914d1d5390d69d0d098ddc89d895a32"
  end

  depends_on "go" => :build

  conflicts_with "deja", because: "both install `deja` binaries"

  deny_network_access! [:postinstall, :test]

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
