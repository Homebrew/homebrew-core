class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/refs/tags/10.0.1.tar.gz"
  sha256 "2562943c29a9b3ce1b76685d9e7de1ad5109f80a35c6941e7853b31fb92641fa"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13657fc94b60b68fa80b2d393b81c93b5d9a7d975fb9205e4d5e6ab84b5a34bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d74ab905a19e5eb0aae6e1495eb4248bc5738b246592e8a252ea3c2c53a18e12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb6018f90ef362ab606375f48eb14516c5f7db69131aa0ff32a1de64e4d1e3b4"
    sha256 cellar: :any,                 arm64_linux:       "fe80de3650973d0fcb15d36e2c842f0d7e2e3a2f227a7be84c6a2096ea8cbe65"
    sha256 cellar: :any,                 x86_64_linux:      "6344045ce12069850d94066dace6654b38e044c4c028366cdc9e162254fc8eba"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index c2ad9a5..30d1de8 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1885,15 +1885,14 @@ checksum = "a4895175b425cb1f87721b59f0f286c2092bd4af812243672510e1ac53e2e0ad"
 
 [[package]]
 name = "openssl"
-version = "0.10.73"
+version = "0.10.81"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8505734d46c8ab1e19a1dce3aef597ad87dcb4c37e7188231769bd6bd51cebf8"
+checksum = "77823a27f0babb03091cb9ed9ef80af3b39dbc82f97e8fa530374b7dafd87a45"
 dependencies = [
  "bitflags 2.9.1",
  "cfg-if",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
@@ -1926,9 +1925,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.109"
+version = "0.9.117"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "90096e2e47630d78b7d1c20952dc621f957103f8bc2c8359ec81290d75238571"
+checksum = "b47e7e6bb2c38cd930d25a23b40fa52e068c10e85f3e03a7f5ba5aaca5713695"
 dependencies = [
  "cc",
  "libc",
