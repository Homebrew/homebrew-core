class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.17.4.tar.gz"
  sha256 "c2e8a742d55c1e257df25f38adb47b46ecc7b56b9e5ce03f03b2d371d9530195"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a25978fc10c6e5a866c65e5499bac99afbfdbc6040a55a6a77feb5a91329f229"
    sha256 cellar: :any,                 arm64_monterey: "1f77289a447bd70ee44f130390252c796a5ff106be47d8f6902234e15607aef3"
    sha256 cellar: :any,                 arm64_big_sur:  "90a241cec355f4a7605e7966bf9e724bbd820d3d01bc23f1c2f59002c1bbc0c5"
    sha256 cellar: :any,                 monterey:       "208722f6bd8ba55a8f364ddb2192c426805bf474718552273f20da7b32aa34ce"
    sha256 cellar: :any,                 big_sur:        "302d943e65d921a9ba71302cdef3eb25d0f4940b78d28e05b7e7c80bc8055bba"
    sha256 cellar: :any,                 catalina:       "c85985bb7aaff3603202fb4ab8eaa7fead50c532e2f009fc283f8e612974c638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae1f56ad622ee53b91637c56b93f0eb027b680397561516d0b170e069d565635"
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
