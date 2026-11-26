class Brush < Formula
  desc "Bourne RUsty SHell (command interpreter)"
  homepage "https://brush.sh"
  url "https://github.com/reubeno/brush/archive/refs/tags/brush-shell-v0.5.0.tar.gz"
  sha256 "c55a57d399112d5509b17518e756acb613886702bccfe9243ba2020a664fc066"
  license "MIT"
  head "https://github.com/reubeno/brush.git", branch: "main"

  livecheck do
    url :stable
    regex(/brush-shell[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "34ab18f84da319c3aae36432fa06bd1745498fa93d052d45800aca94624f6727"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "271cb2959aaac3f697a92d09db280fec8ae2771a7a3afa5be3a5e620b5248e3d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ec9503a7f1eb8057747fe47ad8ff9c4d6e673bbf441450b8df08f774ee2c586"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c69a807aca6d187be89513ff7a6d1de891d31e35ad272c3a4a237426c6510950"
    sha256 cellar: :any,                 arm64_linux:       "6daba520301a1d3260937b9217e880c80c445f082b2a8391234b8acaa3810035"
    sha256 cellar: :any,                 x86_64_linux:      "d71b53356cd151dcc4b58ec5c83a79a7c2f82df4933bc96219b7aa5b49f6b986"
  end

  depends_on "rust" => :build
  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "brush-shell")
  end

  test do
    assert_match "brush", shell_output("#{bin}/brush --version")
    assert_equal "homebrew", shell_output("#{bin}/brush -c 'echo homebrew'").chomp
  end
end
