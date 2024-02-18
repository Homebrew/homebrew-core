class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/refs/tags/cargo-audit/v0.20.0.tar.gz"
  sha256 "695e8d0526bbc672d227a7f8b4592a5fd6641a9e819767146a8a4e3a32e57e5c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1124eb92d944eb6d971e6269385754db411444f50e95f85d5ad12f53c8520477"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a98d087a97d3d66ca26ca0e44dd8ddb9fef6e015460b82a3a53d553e232eb2d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "962ca301dad1b250a79ad59ee1c468b9318507c91bde1755b1bfb87c9f9fa34f"
    sha256 cellar: :any_skip_relocation, sonoma:         "29fdb64dddf8db4ce4cdbaad7fee584729acd1c5d440063a4c40eb30afb76407"
    sha256 cellar: :any_skip_relocation, ventura:        "9a813f39367920a092ec08bc15ea2bc7ad450d69f38f9ade8f9ea47173a43133"
    sha256 cellar: :any_skip_relocation, monterey:       "8d8f4575de5e3b4ccbd9b8ff130fcebb6fd9052e0a877c0bc2bb3803284c6f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69fe721c469556d29af06370804dc626aa24144192e0fde013893c4a94ddb2ea"
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
