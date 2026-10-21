class Kty < Formula
  desc "Terminal for Kubernetes"
  homepage "https://kty.dev"
  url "https://github.com/grampelberg/kty/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "050c8b0df88f65e1a06863bea99495b77bf2045829825e7e130756f1828c6aa6"
  license "Apache-2.0"
  head "https://github.com/grampelberg/kty.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88593e7982a8fc2929ac521ba89f57271b9b2daed351b307b331f0d5d1ea2886"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "794ce6ac8ca031f30ca1a065287c1819cbbdb0535880ec775eaf45151ef903a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ce2b07cbf056aa2e8ce27717228a7dff0698a1c76bdf8063f5f0a0ef18aada5"
    sha256 cellar: :any,                 arm64_linux:       "ff917a6e4e85ea8e646a03be5b192c6ebfbcd92bb57e3cb235084c329aeeb443"
    sha256 cellar: :any,                 x86_64_linux:      "154d8132959707a364b2b27fb2ece9676ec0713ae372870998f8374d28c3d1c7"
  end

  # Last release on 2024-09-16, last activity 2024-10-03
  deprecate! date: "2026-10-15", because: :unmaintained
  disable! date: "2027-04-15", because: :unmaintained

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    inreplace "Cargo.toml", "0.0.0-UNSTABLE", version.to_s
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kty -V")

    assert_match "failed to read an incluster environment variable",
                 shell_output("#{bin}/kty users check brew 2>&1", 1)
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 26df940..fcf58af 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2494,9 +2494,9 @@ checksum = "c08d65885ee38876c4f86fa503fb49d7b507c2b62552df7c70b2fce627e06381"
 
 [[package]]
 name = "openssl"
-version = "0.10.66"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9529f4786b70a3e8c61e11179af17ab6188ad8d0ded78c5529441ed39d4bd9c1"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.6.0",
  "cfg-if",
@@ -2526,9 +2526,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.103"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7f9e8deee91df40a943c71b917e5874b951d32a802526c85721ce3b776c929d6"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
