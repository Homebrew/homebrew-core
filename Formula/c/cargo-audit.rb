class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/rustsec/rustsec/archive/refs/tags/cargo-audit/v0.23.0.tar.gz"
  sha256 "9d3950c98058e14c3ee82d73632581dc12d2e0f655c270169ce95ab3bc9d0cc7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustsec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26c2e643ca2abb08b56753b1a28cec486037824e7748b24d9e272047ad24d5c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c08a2fae8ff011004dd9ea11e52477b73b4e018311df0d71d8f4cec98ee5d12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a342d6b5697760b0bceecdda756fdb471863bf4a5696c353e7307a91de185ea9"
    sha256 cellar: :any,                 arm64_linux:       "5583125dd151ff69ff640d254660bc9af32ce1820021f6caed439837fe431241"
    sha256 cellar: :any,                 x86_64_linux:      "77f81635a0a6acd3315533a78717bf8b1ac010513da3b5dcc01bbeff53d20f45"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-audit")
    # test cargo-audit
    pkgshare.install "cargo-audit/tests/support/base64_vuln"
  end

  test do
    output = shell_output("#{bin}/cargo-audit audit 2>&1", 2)
    assert_path_exists HOMEBREW_CACHE/"cargo_cache/advisory-db"
    assert_match "not found: Couldn't load Cargo.lock", output

    cp_r "#{pkgshare}/base64_vuln/.", testpath
    assert_match "error: 1 vulnerability found!", shell_output("#{bin}/cargo-audit audit 2>&1", 1)
  end
end
