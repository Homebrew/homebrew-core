class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/rustsec/rustsec/archive/refs/tags/cargo-audit/v0.22.0.tar.gz"
  sha256 "77a739cd31259ce9365716ba1831fd401a4e29b111dea5b27ff567822811c898"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustsec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "081b812983513020dddd43c3e921583347aa1780f85dd744ad4794e545a6914e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8267c0ab28037b82c915da17aae11c9e23764cdd012a7c371c04532a8716256d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1bf7333128b3ad15565fa1fab3add833864949f3556469cc676a8fd98a98be8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c72248e214204d81448af092ae6ca32893ce339e598b12ba472d9cd70a9c6bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae8c7a01bd831f830df00b7420942247320a26575569e07e83728981ab7e53b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccab29bc1251e83250dc6886392a735c79f253dfca3ecd3c173559893770799e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
