class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/cargo-audit/archive/v0.13.1.tar.gz"
  sha256 "f0e6e93f63ff1cef96170270e5f828b5d87f674d1dbab10a6a9849dc08b3406a"
  license "Apache-2.0"
  head "https://github.com/RustSec/cargo-audit.git"

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args

    # test cargo-audit
    pkgshare.install "tests/support"
  end

  test do
    output = shell_output("#{bin}/cargo-audit audit 2>&1", 1)
    assert_predicate HOMEBREW_CACHE/"cargo_cache/advisory-db", :exist?
    assert_match "Couldn't load Cargo.lock: I/O error", output

    expected_output = <<~EOS
          Fetching advisory database from `https://github.com/RustSec/advisory-db.git`
            Loaded 170 security advisories (from #{HOMEBREW_CACHE}/cargo_cache/advisory-db)
          Updating crates.io index
          Scanning Cargo.lock for vulnerabilities (3 crate dependencies)
      Crate:         base64
      Version:       0.5.1
      Title:         Integer overflow leads to heap-based buffer overflow in encode_config_buf
      Date:          2017-05-03
      ID:            RUSTSEC-2017-0004
      URL:           https://rustsec.org/advisories/RUSTSEC-2017-0004
      Solution:      Upgrade to >=0.5.2
      Dependency tree: 
      base64 0.5.1
      └── base64_vuln 0.1.0

      error: 1 vulnerability found!
    EOS

    cp_r "#{pkgshare}/support/base64_vuln/.", testpath
    assert_equal expected_output, shell_output("#{bin}/cargo-audit audit 2>&1", 1)
  end
end
