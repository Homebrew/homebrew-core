class Legba < Formula
  desc "Multiprotocol credentials bruteforcer/password sprayer and enumerator"
  homepage "https://legba.evilsocket.net/"
  url "https://github.com/evilsocket/legba/archive/refs/tags/1.3.0.tar.gz"
  sha256 "92707c3dfd809480714c2b5347d2f6506c8848466986597787671b9ffa8bc461"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/evilsocket/legba.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7fb9ce31373429f6566c8ccc85e4568e4545cf8365e70a0bb6c84fdffcb37491"
    sha256 cellar: :any, arm64_tahoe:       "18ce5957c6d07b386002de9d2f83dc318ce7788e2fc7ec7816e027aa9f2b6abc"
    sha256 cellar: :any, arm64_sequoia:     "7619abab175637216660f5d31d97d4073cd58be4287d60288f6c52a0cde2d620"
    sha256 cellar: :any, arm64_linux:       "16ca014358bb1b79a3a461d1c60802a875066309731ebd58789a062666d5ccb2"
    sha256 cellar: :any, x86_64_linux:      "c439500fe6d78ea8be4a300421649c2aa73a74881b8790c3e70360ca80422564"
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
