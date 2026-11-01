class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "a98332394134c1bdd1078001a3e6737014c9113e720f88f02400c5a48edf911a"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a232373fa84fe5eb465104563ec8e149db192aeedf83d388ae6526342b2665f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a232373fa84fe5eb465104563ec8e149db192aeedf83d388ae6526342b2665f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a232373fa84fe5eb465104563ec8e149db192aeedf83d388ae6526342b2665f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f098c707ab84ff9508b33eb1ba086229f2205ac62420026c7349c8909c739d65"
    sha256 cellar: :any,                 x86_64_linux:      "0a4076ae8d29988b9c1ce840fc630652b488e0e00813ba89cecdbd5fd366c111"
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
