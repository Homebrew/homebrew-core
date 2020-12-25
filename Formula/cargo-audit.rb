class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/cargo-audit/archive/v0.13.1.tar.gz"
  sha256 "f0e6e93f63ff1cef96170270e5f828b5d87f674d1dbab10a6a9849dc08b3406a"
  license "Apache-2.0"
  head "https://github.com/RustSec/cargo-audit.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-audit audit --no-fetch 2>&1", 1)
    assert_match "couldn't open advisory database: git operation failed", output

    output = shell_output("#{bin}/cargo-audit audit 2>&1", 1)
    assert_predicate HOMEBREW_CACHE/"cargo_cache/advisory-db", :exist?
    assert_match "Couldn't load Cargo.lock: I/O error", output
  end
end
