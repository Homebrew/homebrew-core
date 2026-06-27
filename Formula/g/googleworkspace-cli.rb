class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.22.5.tar.gz"
  sha256 "1e55ec8c6ee87fac7d422975604a2d546c35f6d687a1cfaba7c7cc0d3c05663f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18208a0875025ab3617eb6f298f28e101a71b4620eab0ac0bd596fbeafbdf7ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "940f4f2d3150d855468a3f8adba6c72b074f4dad5b6edfb0bd946958ed42b14f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c363973bb433d30f52b2e26bade79a9618edf14ccacbb4b9700979ae92ba7f18"
    sha256 cellar: :any_skip_relocation, sonoma:        "a744eac00148c7177850acbfe7dbba454a42eb6a8da0731ea0b4d091efa363de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ea77549f46310bcfcf89a92b4b5199408f368020b9d1a477be1bd8381509ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2845bb156bcd2e92cc01208d747b99e460d3d0408977488ad8b6e18dcac5a332"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/google-workspace-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 2)
    assert_match "Access denied. No credentials provided.", output
  end
end
