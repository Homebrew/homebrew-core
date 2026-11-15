class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "3494e023a198c83bb71e9d0fea3c42f815e2b6f8c3774d9a3b9cae990bed45ac"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a48ee5babc9d83906e7c0eeeed7726e348f8df9bc5b8348c4e82e885150030d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "429f5c4c80f0ffd9055081192332252947a838be44974b78dd323777b49ebd95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "199d8baefeedd8e32756333bd214eb94709184a0931ceb39ae328d4d706aaee5"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "hw.nperflevels", shell_output("#{bin}/macmon debug 2>&1")
  end
end
