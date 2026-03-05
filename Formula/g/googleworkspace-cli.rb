class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "0013c992d7381ce8d5e5d09c79a132a2c5e548e9e310797ab84e301488856192"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bea1a3a86e4d49860b36d7461b411ac4f6331c4b055596144be8d1d4d24434b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e572348cce0e39c6d3ea445b06b0fb25bf69001912525ea3a9db3111a6209fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72b5349a10561b8065ec9fb17f8088a27064b310a998e5cddbb2b1a348791df6"
    sha256 cellar: :any_skip_relocation, sonoma:        "96910daf2fa1b807e35af5ca9584d5a79952efe622171f933fb70b583f8d032a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b09c58702a205d4dd5bddf2f4ffb11dfbbd4708baa08d4a2e8d3ac3500d5f9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "446f6910f1286cdfa74bbc74c7c7aca117bba37bfd53971730a34fe6052cf93e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 1)
    assert_match "Access denied. No credentials provided.", output
  end
end
