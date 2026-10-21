class LanguagetoolRust < Formula
  desc "LanguageTool API in Rust"
  homepage "https://docs.rs/languagetool-rust"
  url "https://github.com/jeertmans/languagetool-rust/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "fc3dfcb73f21c58bb143b5f31495892755bc1e945aa64f522f3640e1cf77de31"
  license "MIT"
  head "https://github.com/jeertmans/languagetool-rust.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b545ad2bd2bcbd455b619a5b86bc88df5dd00df8210ded8d7c65da7db1995d7b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5fec5c6b9c67855eb67a081cf23592084b04a8707b4d6de948f62e64c77ac401"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "085ea279b93c2306d1338207e4f7314f2ff116bc76ab668caffba6380e127fe9"
    sha256 cellar: :any,                 arm64_linux:       "64e765f5754fc2d38accff93e16a3a0594625d6fcc81912a7649f1bd43203f4c"
    sha256 cellar: :any,                 x86_64_linux:      "8a2fc26e1c832b9302eac6e0ce5b577a5fb89e6c529f740b1cceb0c1c7e40b37"
  end

  depends_on "pkgconf" => :build
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
    system "cargo", "install", *std_cargo_args(features: "full")

    generate_completions_from_executable(bin/"ltrs", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ltrs --version")

    system bin/"ltrs", "ping"
    assert_match '"name": "Arabic"', shell_output("#{bin}/ltrs languages")

    output = shell_output("#{bin}/ltrs check --text \"Some phrase with a smal mistake\"")
    assert_match "error[MORFOLOGIK_RULE_EN_US]: Possible spelling mistake found", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index f270356..602bba8 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1365,9 +1365,9 @@ checksum = "d6790f58c7ff633d8771f42965289203411a5e5c68388703c06e14f24770b41e"
 
 [[package]]
 name = "openssl"
-version = "0.10.74"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "24ad14dd45412269e1a30f52ad8f0664f0f4f4a89ee8fe28c3b3527021ebb654"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags",
  "cfg-if",
@@ -1406,9 +1406,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.110"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0a9f0075ba3c21b09f8e8b2026584b1d18d49388648f2fbbf3c97ea8deced8e2"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
