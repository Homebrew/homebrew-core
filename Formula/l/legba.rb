class Legba < Formula
  desc "Multiprotocol credentials bruteforcer/password sprayer and enumerator"
  homepage "https://legba.evilsocket.net/"
  url "https://github.com/evilsocket/legba/archive/refs/tags/1.3.0.tar.gz"
  sha256 "92707c3dfd809480714c2b5347d2f6506c8848466986597787671b9ffa8bc461"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/evilsocket/legba.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "8fd0128668a738b9e2b4d63c77004d2a64871f9a9468f0c4671e214be3158e3a"
    sha256 cellar: :any,                 arm64_tahoe:       "9b5ffcfb622129d9e1e4e15eb23c7f5d41fb299ec3abf804847258fa5bcf4603"
    sha256 cellar: :any,                 arm64_sequoia:     "cc7a31566e35d829a6ff13fe615f6efaacd6221d0ada8968842f396ab82a45da"
    sha256 cellar: :any,                 arm64_sonoma:      "32723c6d82955620f6962a68727031f0b3b33ced6e973b410900259d1fc91857"
    sha256 cellar: :any,                 sonoma:            "dc4a48eb2642cc1c8dcee96f5b326f69074e658015e08b1b31b26feec732034c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c9970fd099b0d1b6963fce8861fa80e828c2ff4c076c1c964ac11c4e734b0570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "72d0ffcc00f11eb2befb1c6a5a7a7b13fbf2b574ebe73db7a3821387a82bc12c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "samba"

  uses_from_macos "llvm" => :build # for libclang

  # Minimum versions of openssl/openssl-sys to support OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"legba", "--generate-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/legba --version")

    output = shell_output("#{bin}/legba --list-plugins")
    assert_match "Samba password authentication", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 199b22d..c44dce9 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -4332,9 +4332,9 @@ checksum = "c08d65885ee38876c4f86fa503fb49d7b507c2b62552df7c70b2fce627e06381"
 
 [[package]]
 name = "openssl"
-version = "0.10.73"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8505734d46c8ab1e19a1dce3aef597ad87dcb4c37e7188231769bd6bd51cebf8"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.9.1",
  "cfg-if",
@@ -4373,9 +4373,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.109"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "90096e2e47630d78b7d1c20952dc621f957103f8bc2c8359ec81290d75238571"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
