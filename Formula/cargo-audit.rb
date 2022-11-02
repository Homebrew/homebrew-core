class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.17.3.tar.gz"
  sha256 "e8b4c3d9178c93818493a33c2524b3b1362fb198d25bb8cbf2887f7ee7bd1c28"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9d594a62e13f0ecc570a8d33df57f88886c92545de3029472f81d95c4250400f"
    sha256 cellar: :any,                 arm64_big_sur:  "7c0b03f22c47ae287aae7dd9a202bbd4a247380868fcf654fca7eec692c733cf"
    sha256 cellar: :any,                 monterey:       "5327021d85ceb504a3a25c9dfff72df04ea7c3333dcba3c55862eb74e07e7494"
    sha256 cellar: :any,                 big_sur:        "5ea11fb2f925cf1db704ec335419f2ce1825890e296972ab3cc71a251392ddc8"
    sha256 cellar: :any,                 catalina:       "0910e393a014c82dc37fbddb5cd86a6531918accc702534b8078fc9c033b5645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "427a4d544d030df1b347743fad8dcae3653231a4c14549f36565e7341eb903c8"
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
