class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.18.1.tar.gz"
  sha256 "ea0e126596a69b27a91328eef451064d8d74dc28c7976dbcca01bd53ebf64370"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "288a71c6c61de41b3527f65a57047fc074d8a53d086cbf33c6811cf21a75b6ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68af5ad97c3bb1dff286e0799be683d918a5d53a5dd1f8710c0f6d39f071dd73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2a80f83dcfe1a1fd9cc9537a733a70dc15c5d15c049358cce0c35e799532bc1"
    sha256 cellar: :any_skip_relocation, ventura:        "1c01938b324da6039bd68fb7253d1022d13492ac05500a339fb7183ecf7f1442"
    sha256 cellar: :any_skip_relocation, monterey:       "1e6c9203ee7adb3b421bea3bfc4f098277c20e3dfda549ca939a4c58b895ea7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e821ed73794c61f5e9d1cdd71a087e66678d0a74ca53e107ea22f8ef26da5a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af778640713fd93b14b570d2148acd2eeaa3df34bcaee21f33cc6e0b1d6b872"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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
