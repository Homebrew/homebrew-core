class MaccleanupRust < Formula
  desc "Fast Mac cleanup utility written in Rust"
  homepage "https://github.com/gappa55/maccleanup-rust"
  url "https://github.com/gappa55/maccleanup-rust/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c68392c5346126f26a100c0745e3ab6a73cf3554209b5bca332853059bc75458"
  license "MIT"
  head "https://github.com/gappa55/maccleanup-rust.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "Mac Cleanup Tool (Rust Edition)", shell_output("#{bin}/maccleanup-rust --help")
    assert_match "DRY RUN mode", shell_output("#{bin}/maccleanup-rust --dry-run")
    system bin/"maccleanup-rust", "--help"
  end
end
