class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://blog.kali-team.cn/projects/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2026.6.28.tar.gz"
  sha256 "36be8c3c6e6169eb5dfff450fe9d16372dac5a5a8b5d47a6c466555772bd7f74"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a255b83b1a397d744c0f2173f88abdf9d1c7be97a4b7c175b761f8e03ac6fcf3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7401b12b1c42742f2682484d7ff4320059a11d3b212521ca8623e3a718563e56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a35d6f9814f5e6123e93ba43438dcf16f1272689f00aad092a068ed35a30e65"
    sha256 cellar: :any,                 arm64_linux:       "eb30c91e5c827c040d6a933130f74c2278cc931cbf9105205837d5e6865d85fa"
    sha256 cellar: :any,                 x86_64_linux:      "04ff30946786bd3ff96d8799606ef46361cef1f9a9a91940fa05a16d138dce23"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index d2a52ba..a4591b9 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2298,9 +2298,9 @@ checksum = "9f7c3e4beb33f85d45ae3e3a1792185706c8e16d043238c593331cc7cd313b50"
 
 [[package]]
 name = "openssl"
-version = "0.10.76"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "951c002c75e16ea2c65b8c7e4d3d51d5530d8dfa7d060b4776828c88cfb18ecf"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags",
  "cfg-if",
@@ -2345,9 +2345,9 @@ dependencies = [
 
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
