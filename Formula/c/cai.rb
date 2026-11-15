class Cai < Formula
  desc "CLI tool for prompting LLMs"
  homepage "https://github.com/ad-si/cai"
  url "https://github.com/ad-si/cai/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "5a2cc76aae7ebbc691ac5705749c254c95fda1c423418da9dfc869503a4229a6"
  license "ISC"
  head "https://github.com/ad-si/cai.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93b21fa8a93bdeceaeee5602aff6ec20a37531838301c7e206b654c783c9f2eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "890bb719c57400c15194a29ae58030ff0336388867160fef52c274a66b2afd48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6d80bb57c4680926f8c7bc6496374a0f5ba61901a5f9e651387700f7321b332"
    sha256 cellar: :any,                 arm64_linux:       "c40f4f584503d48b06a192931bdc8a17b35ebb5acc7bd4e53d0240e26781805a"
    sha256 cellar: :any,                 x86_64_linux:      "9b17f825dfa5d8c015e568e31d8a98fbd0f45659185efea88fb4d14d12893881"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cai anthropic claude-opus Which year did the Titanic sink 2>&1", 1)
    assert_match "An API key must be provided", output

    output = shell_output("#{bin}/cai ollama llama3 Which year did the Titanic sink 2>&1", 1)
    assert_match "error sending request for url", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 528e8f2..0f249d0 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1981,9 +1981,9 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.68"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6174bc48f102d208783c2c84bf931bb75927a617866870de8a4ea85597f871f5"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.11.1",
  "cfg-if",
@@ -2013,9 +2013,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.104"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "45abf306cbf99debc8195b66b7346498d7b10c210de50418b5ccd7ceba08c741"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
