class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.15.1.tar.gz"
  sha256 "48c7e72dcc406c2d2c1425f52b797b05b850e74b978a4b29db1264593160b374"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5e8059900b81f49fedfe479e72848540cb6039f0d2a936f7ac88beb0d3628773"
    sha256 cellar: :any, big_sur:       "b744c2fec00f884a3d519852109e95ca059ab196eb3c8ec961cde2beff18a5af"
    sha256 cellar: :any, catalina:      "e2e898ca14b04941aa3156a559a6d206c30b702e15f357e1f0ce80cd05e8243b"
    sha256 cellar: :any, mojave:        "23d7b5280e15a08a5581a681616b1b1310ab2ad92bd99c7c180abf5b053c8688"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

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
