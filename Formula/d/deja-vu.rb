class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "de46e44a98058bd515d2799a0ee906e3d7600e187ad3eee3d248127378d15f76"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "030c93bb3ec73dcb106de45b1afb5a23ed761eaf319651d9b4dde9444d70ca4e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "030c93bb3ec73dcb106de45b1afb5a23ed761eaf319651d9b4dde9444d70ca4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "030c93bb3ec73dcb106de45b1afb5a23ed761eaf319651d9b4dde9444d70ca4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4e99fcf3246e45c182d31cf7a747990efa836677cfb033b52b5f007adfe62a7f"
    sha256 cellar: :any,                 x86_64_linux:      "1453777f2a43578b53a6f6550c351bbd6fc6253717a79f70e8fb5a617c41a6da"
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
