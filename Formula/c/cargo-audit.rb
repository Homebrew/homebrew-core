class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/rustsec/rustsec/archive/refs/tags/cargo-audit/v0.21.1.tar.gz"
  sha256 "a8ef61e08118fdaa0a9adc18983bc59e904bb1e4a069f8fe73b91da061365969"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustsec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7461ab322993d8923d82272cddfc540c0b1f48422a7c19dce36ec6a26864f253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b8f73dc1eb5c815b756e8075ae4c3e553cd24fbc457810961e38f2e9e331835"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e414ec717a9bdfef947a0c1da5e1b0a63141ddff874848c527b3cfda500ccb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2a34aca923988211da4fbaa248d9b22880c54809d01a6857187531b361308ae"
    sha256 cellar: :any_skip_relocation, ventura:       "7cb18b87aaca5f38f42f26b0e19ca437e8fc9d685ed4f858bf621fc62c5152a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40c4b34aab22c8514293604115e3e6faa146c1dd830a2519103c45ef42fd1175"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-audit")
    # test cargo-audit
    pkgshare.install "cargo-audit/tests/support"
  end

  test do
    output = shell_output("#{bin}/cargo-audit audit 2>&1", 2)
    assert_predicate HOMEBREW_CACHE/"cargo_cache/advisory-db", :exist?
    assert_match "not found: Couldn't load Cargo.lock", output

    cp_r "#{pkgshare}/support/base64_vuln/.", testpath
    assert_match "error: 1 vulnerability found!", shell_output("#{bin}/cargo-audit audit 2>&1", 1)
  end
end
