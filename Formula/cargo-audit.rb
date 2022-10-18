class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.17.2.tar.gz"
  sha256 "6889af7fde60ad00f1702808c8d57b603c8b8be3cc9f64e8c2e8206cb0742c4c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e398b032a265bac41b24da7ab3e985cd4f3383a680c4f7dbfd9a61316f8cb9d9"
    sha256 cellar: :any,                 arm64_big_sur:  "39249855c5163de608bca06d2ea0cf0a744cb842053cce5df0764ed5f7901747"
    sha256 cellar: :any,                 monterey:       "49c8f8ee8305c8108811449db8f68ce2cf49e52bc5f8e01f33963049d7da731d"
    sha256 cellar: :any,                 big_sur:        "3a90b8780993c6280f97e16d39228e349b6a940f779ce071fe2508a3c85455be"
    sha256 cellar: :any,                 catalina:       "a3c894ff0d0124aeb5b5537e33d99d7e5ab4f19c602a5e7e8a10cbb16974ef80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0b9eb0b4d8babfb84eaa7cbbf1465d56a94b21c4c888f36eece349b0371c050"
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
