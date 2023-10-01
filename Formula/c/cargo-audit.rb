class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.18.2.tar.gz"
  sha256 "d513e2811912d0f82b7c245eb2fdeda8b8aa2c81cca969ed56ef2afbe1fc2e7a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33541bee5224bffe23c8fb5f364cc64692e88a95fa5805cbf93d893e0e7218cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51628be24c962dc403157126de9a93c5e3098b01b05d36e0537fded089f0c5ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f68dbadfda862b5e333507b8e974d6d3a05f9b9887bc0897e82704c75e8e4042"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9bec470c89a9b16e17575e7ec0f5567c4746549e1975b9921db4f8f02117577"
    sha256 cellar: :any_skip_relocation, ventura:        "ebef70df4d9b98e9b4d60e3a0395b7e50e677b38963ea85f455088134c313e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "a36976f59f5807221e37d542201d4068ee219c791f2e1f57ff903390624d6ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e9089ca10db8a414764a7009267e00a07e4b3d9d380a5e6c3d8bdf2a214369"
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
