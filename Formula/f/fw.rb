class Fw < Formula
  desc "Workspace productivity booster"
  homepage "https://github.com/brocode/fw"
  url "https://github.com/brocode/fw/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "9a8b3b1f483118597e07de9561c0fac3412b896aa950243726ef553a705561ac"
  license "WTFPL"

  # This repository also contains version tags for other tools (e.g., `v4.4.0`
  # is an `fblog` tag), so we can't reliably determine which tags are for `fw`.
  # Upstream only creates GitHub releases from `fw` tags, so we have to check
  # releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "dc4c1ec645f55270517cdf132ff267beb18bc35a156b91b3e9690e17e6bb227a"
    sha256 cellar: :any, arm64_tahoe:       "1fb2b437ff237ac4fa943a4d9adb5cc7f05e61f1edb233e7b2bafedf386c5c23"
    sha256 cellar: :any, arm64_sequoia:     "d7f33f20be35a9b61b687cbb6473d10b1273f03a384f2b37953843689a935f4d"
    sha256 cellar: :any, arm64_linux:       "0bf676395e4e6334aac5d4953a303cac406c728ae261e471b9ec59e38f7c59ea"
    sha256 cellar: :any, x86_64_linux:      "6a5c1d47ac5c682c646770e836aca13973ffd07e2720f7051da523abe82dc28a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  resource "fw.1" do
    url "https://github.com/brocode/fw/releases/download/v2.21.0/fw.1"
    sha256 "2c27213d3c5dea906000ccb363ca70f167da0f67e74c243a890a935a102b3972"

    livecheck do
      formula :parent
    end
  end

  # Backport https://github.com/brocode/fw/commit/de58a9ec7ecef5d1c5dbb0112a948222d4984732
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
    man1.install resource("fw.1")
  end

  test do
    assert_match "Synchronizing everything", shell_output("#{bin}/fw sync 2>&1", 1)
    assert_match "fw #{version}", shell_output("#{bin}/fw --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 6997124..930ebe1 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -958,9 +958,9 @@ checksum = "a4895175b425cb1f87721b59f0f286c2092bd4af812243672510e1ac53e2e0ad"
 
 [[package]]
 name = "openssl"
-version = "0.10.72"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fedfea7d58a1f73118430a55da6a286e7b044961736ce96a16a17068ea25e5da"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags",
  "cfg-if",
@@ -999,9 +999,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.108"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e145e1651e858e820e4860f7b9c5e169bc1d8ce1c86043be79fa7b7634821847"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
