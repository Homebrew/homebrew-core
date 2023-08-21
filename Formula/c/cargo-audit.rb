class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.17.6.tar.gz"
  sha256 "d509de3528a2d5c1ee78bf0750ba768f1c9c7cabf1e45d366cb1aed64be514fa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "046086e02b721df8df466061e7c4ac0f057ec503f2d6ce15279a63614abf77ce"
    sha256 cellar: :any,                 arm64_monterey: "b23a0660abdf62e0feb79e4695c177b95d940becf34d46777879f3351cf64cd0"
    sha256 cellar: :any,                 arm64_big_sur:  "49737b1629a7aac33366313bb5046829b597aaabad95eacd5be22bbb5b235e37"
    sha256 cellar: :any,                 ventura:        "41efc517ed18bb33323d1dd27546e42cd9747d9ec075ca3993ecfd6279dc1065"
    sha256 cellar: :any,                 monterey:       "ec368f993a0b6aa778ba19c06d3578d9e1cbfc1233197b7dc00a360b6ba36e19"
    sha256 cellar: :any,                 big_sur:        "285db0168609075b6a99b57e2e10e428bc3c06324b36e4aa712b0898eaba46ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4dd92efe0a87e08b9c3bb1b79fb65535c1c131f1518af3f312c1f043e8554b6"
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
