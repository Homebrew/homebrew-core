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
      # Test that the binary exists and shows help
      assert_match "Mac Cleanup Tool (Rust Edition) By Gappa", shell_output("#{bin}/maccleanup-rust --help")

      # Test dry run mode works without errors
      assert_match "DRY RUN mode", shell_output("#{bin}/maccleanup-rust --dry-run")

      # Test version information
      system bin/"maccleanup-rust", "--help"
    end
  end
