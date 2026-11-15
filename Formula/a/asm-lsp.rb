class AsmLsp < Formula
  desc "Language server for NASM/GAS/GO Assembly"
  homepage "https://github.com/bergercookie/asm-lsp"
  url "https://github.com/bergercookie/asm-lsp/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "9500dd7234966ae9fa57d8759edf1d165acd06c4924d7dbeddb7d52eb0ce59d6"
  license "BSD-2-Clause"
  head "https://github.com/bergercookie/asm-lsp.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c2955de377dd27c4226e64d2701f0e14086a85dce4d43635dbcbc84ac4e4f35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4429273d74303faa38c6fbb7b2074db7c922da25dd9d347624b6a263d21e4ba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc076b8590b27a9df2f227487ff8c19e6b13e084d236a572c074431ba9faf7a3"
    sha256 cellar: :any,                 arm64_linux:       "c51bd28c18b4202f1090fb19001f73eee16696fd957944001fc021edfaeb0735"
    sha256 cellar: :any,                 x86_64_linux:      "a89c93ae414c3f676164659e470b5c750850b570ac540e7899075dd6a02899b3"
  end

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
    system "cargo", "install", *std_cargo_args(path: "asm-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asm-lsp version")

    expected = if OS.mac?
      "Global config directories"
    else
      "Global config directory"
    end
    assert_match expected, shell_output("#{bin}/asm-lsp info")

    output = shell_output("#{bin}/asm-lsp gen-config 2>&1", 101)
    assert_match "not a terminal", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index f2857fb..085da16 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1415,9 +1415,9 @@ checksum = "1261fe7e33c73b354eab43b1273a57c8f967d0391e80353e51f764ac02cf6775"
 
 [[package]]
 name = "openssl"
-version = "0.10.72"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fedfea7d58a1f73118430a55da6a286e7b044961736ce96a16a17068ea25e5da"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.8.0",
  "cfg-if",
@@ -1447,9 +1447,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.107"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8288979acd84749c744a9014b4382d42b8f7b2592847b5afb2ed29e5d16ede07"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
