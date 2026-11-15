class GitXet < Formula
  desc "Git LFS plugin that uploads and downloads using the Xet protocol"
  homepage "https://github.com/huggingface/xet-core"
  url "https://github.com/huggingface/xet-core/archive/refs/tags/git-xet-v0.2.1.tar.gz"
  sha256 "df2a90a8266918bf2aba35e22276c745d11bd9c39850410f78ebbf2b50d0c87c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^git[._-]xet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "00a4ff72f704f5acdf38b43eb14501d5bb7383f33523f582582a262a617220ef"
    sha256 cellar: :any, arm64_tahoe:       "91b3c6e5e9ba6482d854737066467323555636a7604a7efb0653ea5cb28adfc1"
    sha256 cellar: :any, arm64_sequoia:     "fd965e43ac38be4e2a6a5c11ef44ad2a825b4194336f4e2f64337a7996564049"
    sha256 cellar: :any, arm64_linux:       "1e82e7d933142b32f569609d66d80f0d7500b781175a7b91dca9a4970889cecc"
    sha256 cellar: :any, x86_64_linux:      "472b4c171be575980c172078675a14ebd2c440599e51659a18cec2b17d4ea90d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "git-lfs"
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport only the openssl and openssl-sys version updates from
  # https://github.com/huggingface/xet-core/commit/feb8ddb6fd47233d513102880b98551bba7c5f6b
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args(path: "git_xet")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xet --version")
    system "git", "init"
    system "git", "xet", "track", "test"
    assert_match "test filter=lfs", (testpath/".gitattributes").read
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 66ea4161..a31cc520 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -3010,15 +3010,14 @@ checksum = "c08d65885ee38876c4f86fa503fb49d7b507c2b62552df7c70b2fce627e06381"
 
 [[package]]
 name = "openssl"
-version = "0.10.72"
+version = "0.10.79"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fedfea7d58a1f73118430a55da6a286e7b044961736ce96a16a17068ea25e5da"
+checksum = "bf0b434746ee2832f4f0baf10137e1cabb18cbe6912c69e2e33263c45250f542"
 dependencies = [
  "bitflags",
  "cfg-if 1.0.4",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
@@ -3051,9 +3050,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.108"
+version = "0.9.115"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e145e1651e858e820e4860f7b9c5e169bc1d8ce1c86043be79fa7b7634821847"
+checksum = "158fe5b292746440aa6e7a7e690e55aeb72d41505e2804c23c6973ad0e9c9781"
 dependencies = [
  "cc",
  "libc",
