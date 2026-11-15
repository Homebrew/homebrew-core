class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://blog.kali-team.cn/projects/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2026.11.3.tar.gz"
  sha256 "1e1f571be683b6698fb3fdaaf89ecc902a0f4ce862462ce343f2f6357f2aa878"
  license "GPL-3.0-only"
  head "https://github.com/emo-crab/observer_ward.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "790f921122effe3f4fe4f0f4b5febc0237cf797c48e8668eac523bde7a8cd00c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad45962a94360f7db14ec4faca26119e7ce57dda2d5d44fc8a1e7f759005563b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c2e0a7b68b60d16c7fc1742c816388e4d28500a60313a205624210937b46901"
    sha256 cellar: :any,                 arm64_linux:       "642535bbda7069d78928c04d69525a9efab01341b900a6427fe3aaaba395d1f0"
    sha256 cellar: :any,                 x86_64_linux:      "de9fd16e1a9d2f2ee9900966bdca3124893a8ff8437e2d7e88eb1d5c2e57588a"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
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
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
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
