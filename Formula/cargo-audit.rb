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
    sha256 cellar: :any,                 arm64_big_sur: "a7954b9aff8d7d2ddac189fbd800a5f38e91e6b6259a8c951df47dc11fe97337"
    sha256 cellar: :any,                 big_sur:       "f6337c09242e9f1db0b2952e461558c79ae9b95caa7e76e1483d9027ddf67fb8"
    sha256 cellar: :any,                 catalina:      "8383cf15d8e5f83890e46628786b5aa293453d00255a10e963d16567cdad44bf"
    sha256 cellar: :any,                 mojave:        "3bc087889fb025d8bd59701e0882d11fec0d4d2678a3fb94a47030d97dc0097b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52fdf4c76b47d450263ce877a991bc4ea68990e1c3ed7003ae34e6ee1b0ebda7"
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
