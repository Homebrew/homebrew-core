class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/cargo-audit/archive/v0.13.1.tar.gz"
  sha256 "f0e6e93f63ff1cef96170270e5f828b5d87f674d1dbab10a6a9849dc08b3406a"
  license "Apache-2.0"
  head "https://github.com/RustSec/cargo-audit.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2ee3fc5de64df2f639b9b8ced769417945789a15a6826886e3f7ce6c11451d1c"
    sha256 cellar: :any, big_sur:       "cc3a589e9754896c184a212e8bfcf2017332299b5769fe0256bbbe791f481258"
    sha256 cellar: :any, catalina:      "ed44448e1d7317cb0cc01cb728065d60b821efa8f2921f4b375793971c6c3aab"
    sha256 cellar: :any, mojave:        "f9f90aa44066dd6591294f78309bed08e88fd88aa3f5d5fcc63b1d0fbc77de2d"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args

    # test cargo-audit
    pkgshare.install "tests/support"
  end

  test do
    output = shell_output("#{bin}/cargo-audit audit 2>&1", 1)
    assert_predicate HOMEBREW_CACHE/"cargo_cache/advisory-db", :exist?
    assert_match "Couldn't load Cargo.lock: I/O error", output

    cp_r "#{pkgshare}/support/base64_vuln/.", testpath
    assert_match "error: 1 vulnerability found!", shell_output("#{bin}/cargo-audit audit 2>&1", 1)
  end
end
