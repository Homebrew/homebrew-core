class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://github.com/protonpass/pass-cli/archive/refs/tags/2.7.0.tar.gz"
  sha256 "623e6fa0c3d83daa8778e7d6693406f6d5aee82e4b460ddccddb5218322598a4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "932dc1a1b64d2a939ba055cfa58f2d77728a15be54155ddbe3326cefcdf898bb"
    sha256 cellar: :any, arm64_tahoe:       "25d60cf361d9ecc1a333636c5acf3c1f325464da1584a417541630469ad2815d"
    sha256 cellar: :any, arm64_sequoia:     "d94d4dad0f7a761a0c28b314ee2282849957fbe7a4c39f34bf597c4929c69648"
    sha256 cellar: :any, arm64_linux:       "9ede1c58a3c5851a272a8d2cfc7eff70ea692bc033ecb1c1338e9d4432563550"
    sha256 cellar: :any, x86_64_linux:      "caac073346c1910e574f7f02553c4c2075eede2717acb8727fcf037cb25dd5e3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  # Upstream does not currently accept external contributions.
  # Remove `pass-uniffi-bindgen` crate
  patch :DATA

  allow_network_access! :test

  def fetch
    # Regenerate `Cargo.lock` after removing `pass-uniffi-bindgen` member
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    ENV["PROTON_PASS_KEY_PROVIDER"] = "fs"
    output_log = testpath/"output.log"
    pid = spawn bin/"pass-cli", "login", [:out, :err] => output_log.to_s
    sleep 5
    assert_match "Waiting for authentication to complete", output_log.read
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/Cargo.toml b/Cargo.toml
index 8be08b9..380a618 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -8,8 +8,6 @@ default-members = [
     "pass-fs",
     "pass",
     "pass-derive",
-    # maturin runs its `uniffi-bindgen` bin (in the default members) to generate the Python bindings
-    "pass-uniffi-bindgen"
 ]
 resolver = "2"
 
