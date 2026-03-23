class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/rustsec/rustsec/archive/refs/tags/cargo-audit/v0.22.1.tar.gz"
  sha256 "262d42fcca5db8629b6220d84e62e7ffda913846a36089a847ffe276e6b09446"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustsec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b863761905e89bd87009f738a06311ff12c071952b249998a3cfa422da221583"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a3da87bd00d58d6b9fca96be4ed12ce9fc6d44ae6807de7bc5e20da3b66cddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3aa29e243612911982cb490c5805e4632082661241b9e9596da606ef3364332"
    sha256 cellar: :any_skip_relocation, sonoma:        "96c9f3e94687aea1e65ae80ca447e78319125e643019995cec756deec3832244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc4d22172c227e91f20053e8bd799969b9e01c8d413d2d9ed0011367622414ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "303b9c4ba7517e22b93399a9876b8bd69307165ac9eae534db83852e449bbfb9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
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
