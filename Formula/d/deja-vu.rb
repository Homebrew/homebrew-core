class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "a48889624c1d63f078ea8c1d49cd0f22cc0d1e9b15031af72c9eac0a45b3b2a4"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eadb3fd3bf0fb7946c8c052c4e3a48eed7f0b518a942c3dce08a8915b4965e90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eadb3fd3bf0fb7946c8c052c4e3a48eed7f0b518a942c3dce08a8915b4965e90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eadb3fd3bf0fb7946c8c052c4e3a48eed7f0b518a942c3dce08a8915b4965e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "796213baa0ee40224a0a47766a2b41dc6995ebba6177be9c0f2db69d6f03657f"
    sha256 cellar: :any,                 x86_64_linux:      "e0259bd1cab406a06d30dab448796903871fc55477669ebf7851ece57d8bbae1"
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
