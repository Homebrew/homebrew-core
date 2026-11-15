class Intermodal < Formula
  desc "Command-line utility for BitTorrent torrent file creation, verification, etc."
  homepage "https://imdl.io"
  url "https://github.com/casey/intermodal/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "3a072929379ddba929d85a579888ac51cf22e44897b7dc84af7612f49d3874d7"
  license "CC0-1.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6182f32f8d3f901ce2b36018df5a6587299b3a97c6318651b71784ce3e03c7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48e2b42b49eeb7957a74d2e52b44b497049ede8a3cc90aa6589038337e40a605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2837a22ce775db6f40debefd3fd0741209840616585b25bfadad4d6bf29e2fb9"
    sha256 cellar: :any,                 arm64_linux:       "8c5640aa28c15c64e48a753cf6fc0de5ae88c24700d6d2c54d6c330380e5a6d5"
    sha256 cellar: :any,                 x86_64_linux:      "2b4b415b876e4754355772187bb13e85acc904907b4e721eccbc5332c745fbaa"
  end

  depends_on "help2man" => :build
  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "run", "--package", "gen", "--", "--bin", bin/"imdl", "man"
    generate_completions_from_executable(bin/"imdl", "completions")

    man1.install Dir["target/gen/man/*.1"]
  end

  test do
    system bin/"imdl", "torrent", "create", "--input", test_fixtures("test.flac"), "--output", "test.torrent"
    system bin/"imdl", "torrent", "verify", "--content", test_fixtures("test.flac"), "--input", "test.torrent"
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 0cc8c5c..c1e74d4 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1256,9 +1256,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.112"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "57d55af3b3e226502be1526dfdba67ab0e9c96fc293004e79576b2b9edb0dbdb"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
