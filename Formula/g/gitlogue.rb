class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "1d271302883be633d7d8dfdb7540d2382f2ab0742c9772e43a585e769230ea29"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "b9f40652c9e6d75a923c32367442870ea70a40e152714e350d2d5a9310585727"
    sha256 cellar: :any, arm64_tahoe:       "2df4baa13440dc4e1bdd31d47febc9afff67d3bccca02146dfe7d0039253a058"
    sha256 cellar: :any, arm64_sequoia:     "1d08d7b3d9941765454c00734606ef9385226bcae45ee53ce522a602f01cd9d7"
    sha256 cellar: :any, arm64_linux:       "7aa41d3a8cccb77fa0e53ca1ec765159b6d00801038d454602bbdaaa668fec2d"
    sha256 cellar: :any, x86_64_linux:      "290e44420f605f258efc3fad78b9e49e7eb85620ce3b51f1024ef25d041b4aa1"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  # Issue ref: https://github.com/unhappychoice/gitlogue/issues/226
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 698ae5b..ce63719 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1197,9 +1197,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.111"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "82cab2d520aa75e3c58898289429321eb788c3106963d0dc886ec7a5f4adc321"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
