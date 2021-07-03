class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.15.0.tar.gz"
  sha256 "af5a7d7c681d1956433ec4bc239bfb2c24df90731ae514a7cd3ca909562f9855"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5135cd085b6e2a687ac7e64fa7c0c38dc75132f1aeb628cb096e67dc51e5cd20"
    sha256 cellar: :any, big_sur:       "4e45de8a4031f71511991181b941ce01e77c095020ddee580a2d9acc053ff958"
    sha256 cellar: :any, catalina:      "1e64730b7d7d3212bc3a6d2095f436d31a6dc3024edf0c2372abd058598472c8"
    sha256 cellar: :any, mojave:        "c3b4a847138404b1500c94a4eca5d1b3f8a9bda86f7976856306cf5c251e362c"
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
