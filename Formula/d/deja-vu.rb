class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "3105799fff70aba142978b3864366d274d020844fd50fea7a3837c5e0a3c2ce0"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7b17bc0d9288bc328ebbb2c58a31247067391ef136af19a7a4d5fa9b2e54508"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7b17bc0d9288bc328ebbb2c58a31247067391ef136af19a7a4d5fa9b2e54508"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7b17bc0d9288bc328ebbb2c58a31247067391ef136af19a7a4d5fa9b2e54508"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dbd94d7083e0f8ca3c570caba1a4bf5469f53a943088558ff5e5a442ac17b416"
    sha256 cellar: :any,                 x86_64_linux:      "b5a421ed1645f797d942cc8873aeb22a17fdadca6b5d702ccc46c3c8211d2101"
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
