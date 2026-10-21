class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.32.tar.gz"
  sha256 "fd6585717448b796d90b7b6dadd609c86c806ee7b4c9f0a21e27ffb47e8ff59c"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "be419029c1e23e7ad5b8934223e5be7f4f899982491c28bdf79f750dd07e86c7"
    sha256 cellar: :any, arm64_tahoe:       "18b253c0b3461a2523923cb782e4f2f78ae235de45173ba730254f44874f2dc6"
    sha256 cellar: :any, arm64_sequoia:     "f1a43dd16bd2d9bd898c2cd05a21261fcece71eaafa781b5358d615ecd4a1e5d"
    sha256 cellar: :any, arm64_linux:       "b8dee93eb963968c78f6662a4e9766877717def3768a53422c8acb43e8457666"
    sha256 cellar: :any, x86_64_linux:      "f93637985748e428d8f0ec52c2c365b5a8c4d9cbb70a2dae56f3cf205f9f7fcd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "sqlite" # needs sqlite3_load_extension

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
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    rm_r(buildpath/".cargo")
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password --username x 2>&1", 1)
    assert_match "incorrect credentials", output

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 2144927..0a20b5f 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -4434,9 +4434,9 @@ checksum = "c08d65885ee38876c4f86fa503fb49d7b507c2b62552df7c70b2fce627e06381"
 
 [[package]]
 name = "openssl"
-version = "0.10.70"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "61cfb4e166a8bb8c9b55c500bc2308550148ece889be90f609377e58140f42c6"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.8.0",
  "cfg-if 1.0.0",
@@ -4475,9 +4475,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.105"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8b22d5b84be05a8d6947c7cb71f7c849aa0f112acd4bf51c2a7c1c988ac0a9dc"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
