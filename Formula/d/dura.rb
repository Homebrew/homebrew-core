class Dura < Formula
  desc "Backs up your work automatically via Git commits"
  homepage "https://github.com/tkellogg/dura"
  url "https://github.com/tkellogg/dura/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6486afa167cc2c9b6b6646b9a3cb36e76c1a55e986f280607c8933a045d58cca"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_golden_gate: "adfa4cc3a97674be422ae3c72b288bc3ebcb93a864de9cee18494388f4424aa1"
    sha256 cellar: :any, arm64_tahoe:       "a30a1ed09056cceda90d2fcc53196016437d8cb5847da7748ac4d778d411e406"
    sha256 cellar: :any, arm64_sequoia:     "e3ca39ded3679352e80e205b5b1c544522cca4db4c1aaf248b35a2a07b57d442"
    sha256 cellar: :any, arm64_linux:       "a2c1463d77514e9f9a57d8756438d36ffb825bfc07681928ca082eea531f8866"
    sha256 cellar: :any, x86_64_linux:      "7c05e53c83873a2985666aa1783241c32ceed7ad4b4fab39f8cb6cba69139dbc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    # Refresh the release's lockfile while retaining existing dependency versions.
    system "cargo", "update", "--workspace"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"dura", "serve"]
    keep_alive true
    error_log_path var/"log/dura.stderr.log"
    log_path var/"log/dura.log.json"
    working_dir var
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    assert_match(/commit_hash:\s+\h{40}/, shell_output("#{bin}/dura capture ."))
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index ced8285..e8862f3 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -670,11 +670,10 @@ checksum = "28988d872ab76095a6e6ac88d99b54fd267702734fd7ffe610ca27f533ddb95a"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.72"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7e46109c383602735fa0a2e48dd2b7c892b048e1bf69e5c3b1d804b7d9c203cb"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
- "autocfg",
  "cc",
  "libc",
  "pkg-config",
