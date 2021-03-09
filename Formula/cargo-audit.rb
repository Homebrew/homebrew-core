class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/cargo-audit/archive/v0.14.0.tar.gz"
  sha256 "bd2ecab6ff03fb11496cd0e7389273991b7d14d19bbdd76847126cb28079519e"
  license "Apache-2.0"
  head "https://github.com/RustSec/cargo-audit.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "94a00879936962e670f0368b378b10ed0f463d290b0e6d86a74c5b01cf6d1bc5"
    sha256 cellar: :any, big_sur:       "e22d5081a6b6bf512c5b1486ac6d7cab6f49fce8da27e3bdb9b9bba7d812cf3a"
    sha256 cellar: :any, catalina:      "b5630a5dc10e0b1bd98274c91fc4cd8c2ccca002b0ed5eca2f72c7b5b65d356b"
    sha256 cellar: :any, mojave:        "68c918a7951990e869829f6d80421aa12968da30e9d93ba1569a6a012b2290ee"
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
