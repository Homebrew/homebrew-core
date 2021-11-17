class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.16.0.tar.gz"
  sha256 "f0370c87c7a7976387303c7b5cc06651979968358b4f4dc867d30d65fab4d323"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "03bf27001ce35f5885c14b517d1cb9b496a6092f5a91636483f3c11e1dc3cbee"
    sha256 cellar: :any,                 arm64_big_sur:  "5825e17552507d413d261f30dfc0c3597e5d9e538ea966ba66d6c6f98e2bfafe"
    sha256 cellar: :any,                 monterey:       "306826ea9ffc42f17de0ff4a92e5ad51e47fcbf92c7d646942eb5fd78f09dfef"
    sha256 cellar: :any,                 big_sur:        "0930e9a08ceeaa5fde11066edf2b9212f9177c2750ff018fe3ae993156d6f1d7"
    sha256 cellar: :any,                 catalina:       "618b98672a077ad25f0d71e2fee12f17721b1ab1fe33d4842e46ce512c950b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92cfa76ab250fd2b2dc8be2839eb36bca2d9f73fdf811451022d6a0c0083fe62"
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
