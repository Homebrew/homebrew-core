class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.15.2.tar.gz"
  sha256 "ed330d33f86036acd27ab8f717903aa515c306d02217aa217c95e2a5fdab1f8e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1128c40f80778bc64398f58d4b9a3d87954761d467cd9fb28b0a56d4a1f42dda"
    sha256 cellar: :any, big_sur:       "06fb7f60f3f60ecb116d849c85619ffb7a693c2d9fb8eb7b178035bd89b37196"
    sha256 cellar: :any, catalina:      "c8f4309e291717fa43b369fb915eb7c3e70fc5474ec0437941a83540ebfcaaf1"
    sha256 cellar: :any, mojave:        "73ee221ba69b1642e16de62a23b59b68dbdc74574eb82da363e9de71c0f98a94"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "cargo-audit" do
      system "cargo", "install", *std_cargo_args
      # test cargo-audit
      pkgshare.install "tests/support"
    end
  end

  test do
    output = shell_output("#{bin}/cargo-audit audit 2>&1", 2)
    assert_predicate HOMEBREW_CACHE/"cargo_cache/advisory-db", :exist?
    assert_match "couldn't open Cargo.lock: No such file or directory", output

    cp_r "#{pkgshare}/support/base64_vuln/.", testpath
    assert_match "error: 1 vulnerability found!", shell_output("#{bin}/cargo-audit audit 2>&1", 1)
  end
end
