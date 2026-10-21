class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/", browsed: "2026-09-05"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v9.6.0.tar.gz"
  sha256 "c3386da89449ca7f453b0f92572730d1f08dedc49fd02a5059ddd934321651ef"
  license "Apache-2.0"
  revision 1
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "349d3a216821ff2894d803ccacf5e62ebe485caa22c4c463734c583ec5061404"
    sha256 cellar: :any, arm64_tahoe:       "b78885ba252eb11cb6b63f2e1aee6182f210dfb2e081cfa2df47b1fc9d18ec27"
    sha256 cellar: :any, arm64_sequoia:     "700c2a780c5e9b3639bc8885682655e903023efbecca4e087b0b576d95c20e48"
    sha256 cellar: :any, arm64_linux:       "0a55cbe92fb0471e75e29b801c7cfecebc63aad670606e14d97c17b3654bba0e"
    sha256 cellar: :any, x86_64_linux:      "1d3f461bbd1e4fc802586ccc997cb5f1052004e05abff7a9d9f9ebbf04361a95"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rocksdb"

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "elfutils"
    depends_on "openssl@4"
    depends_on "systemd"

    on_intel do
      depends_on "lld" => :build
    end
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Remove optimization to allow bottles to be run on our minimum supported CPUs
    inreplace ".cargo/config.toml", /,\s*"-C",\s*"target-cpu=x86-64-v3"/, ""

    ENV["ROCKSDB_LIB_DIR"] = formula_opt_lib("rocksdb")

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"

    # stdout is not supported, so install manually
    %w[bash zsh fish powershell].each do |shell|
      system bin/"aptos", "config", "generate-shell-completions", "--shell", shell, "--output-file", "aptos.#{shell}"
    end
    bash_completion.install "aptos.bash" => "aptos"
    zsh_completion.install "aptos.zsh" => "_aptos"
    fish_completion.install "aptos.fish"
    pwsh_completion.install "aptos.powershell" => "_aptos.ps1"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 8c8cd9bc53..dd3199af76 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -14740,9 +14740,9 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.75"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "08838db121398ad17ab8531ce9de97b244589089e290a384c900cb9ff7434328"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.11.0",
  "cfg-if",
@@ -14778,9 +14778,9 @@ checksum = "7c87def4c32ab89d880effc9e097653c8da5d6ef28e6b539d313baaacfbafcbe"
 
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
