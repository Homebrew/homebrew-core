class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/rustsec/rustsec/archive/refs/tags/cargo-audit/v0.21.2.tar.gz"
  sha256 "caf8914af7f95ebb45590c95b5f9bfd71bd6f9f57c1ffcf69dc9d20f0430e578"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustsec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37d7c8d731b959de676423b00493e59db64e57917bb0dc68d07179f2dd056f30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4531b5306ab7477d604aa5eb69f29f1f78a55af839395781efa6ff299e08e7bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77555fa8e19f69321177e152579c220f879b9cd6b4f03030b9641fc593c230d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "98ad36681ebb7db57784efcb950cd2905607770706f8b28c5b37c7821a29a500"
    sha256 cellar: :any_skip_relocation, ventura:       "afbfc3c37db364702cef9ca24de5e540e92e4c7ca63b04868f8cbc27a3a57337"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6291c84ef0972f444e797f761691f982502514ed9b25bf2dc34b2da82fed41f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4e7fd69c4d6cfc594f2a5285da7ed6ef174360ebeb0c8f232711617cbd50430"
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
