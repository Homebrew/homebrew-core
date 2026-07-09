class ArpScanRs < Formula
  desc "ARP scan tool written in Rust for fast local network scans"
  homepage "https://github.com/kongbytes/arp-scan-rs"
  license "AGPL-3.0-or-later"
  head "https://github.com/kongbytes/arp-scan-rs.git", branch: "master"

  stable do
    url "https://github.com/kongbytes/arp-scan-rs/archive/refs/tags/v0.15.1.tar.gz"
    sha256 "6d478b47bdf00c2618e414d87af496892c5027a5a3d4a438ab92c084c36fa5b6"

    # Workaround for https://github.com/kongbytes/arp-scan-rs/issues/9
    patch :DATA
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14bd6fa1bb860ec13b1dc36252df0b426b542579156b511498cb5db789cc3f5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "807c0ba92359a131432f619bad0e1b6013e50f269c4bc79c3d5e47f8dd123089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9844bb9f7c626b59e0e9ee4fc02a030fd8a10941193e110ee37c21f40d4afb31"
    sha256 cellar: :any_skip_relocation, sonoma:        "564410dd322d19205f29167bb1681dd7b9efe81f1bd8ab5d5bb38e537c6a312b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a28a6dea691d50c0e4084c5f4fd9842a814bede065bc9174a41cebd08871c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6750fe3231d3d634a0b9a3d0384479fdb3f658d869443689aa67ad8b6380a1d5"
  end

  depends_on "rust" => :build

  conflicts_with "arp-scan", because: "both install `arp-scan` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arp-scan --version")
    assert_match "Default network interface", shell_output("#{bin}/arp-scan -l")
  end
end

__END__
diff --git a/Cargo.toml b/Cargo.toml
index c0db14d..9b49b3b 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -21,9 +21,6 @@ ansi_term = "0.12"
 rand = "0.9"
 ctrlc = "3.5"
 
-[target.'cfg(target_os = "linux")'.dependencies]
-caps = "0.5.6"
-
 # Network
 pnet = "0.35"
 pnet_datalink = "0.35"
@@ -35,3 +32,6 @@ csv = "1.4"
 serde = { version = "1.0", features = ["derive"] }
 serde_json = "1.0"
 serde_yaml = "0.9"
+
+[target.'cfg(target_os = "linux")'.dependencies]
+caps = "0.5.6"
