class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/rustsec/rustsec/archive/refs/tags/cargo-audit/v0.22.2.tar.gz"
  sha256 "85c368a4d166b2cc4972108d50abc5fad605013b65098929a06122439488beb5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustsec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d9e5dd5e65645fb52c168c0336328dbad40abc2fc170a5baa4307bf8c1c28c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "498ba346f9b85632bdd109d01628b55e14f9bbd1029a5c825fd9a99ea6366553"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da51f6641e369d800fbca0ed01c6944c00a6b231aeba6fd46e6f29ebdca8f9fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "938d5e29897d011acdb211a3b39147333a9b5159066c9063471a3280e86422d3"
    sha256 cellar: :any,                 arm64_linux:   "0a61da38fe81174eeba45b913fe59b913c576bc3ed14fc749fb4f4f9a511ed91"
    sha256 cellar: :any,                 x86_64_linux:  "dd32d845e0faf9522cc25ee4863f3790b80f8a2d22ceda099d83c5918cadc90d"
  end

  depends_on "rust" => :build

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
