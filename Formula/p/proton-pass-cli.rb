class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://github.com/protonpass/pass-cli/archive/refs/tags/2.7.0.tar.gz"
  sha256 "623e6fa0c3d83daa8778e7d6693406f6d5aee82e4b460ddccddb5218322598a4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9b1caab83dc7b26c2c2983482f78cbfd071adae73dda9e12f61c43a864568dad"
    sha256 cellar: :any, arm64_tahoe:       "f57bf27efde4e7071234337378e4bf5453912d9df355eee2d8d231780413f083"
    sha256 cellar: :any, arm64_sequoia:     "7c96e30d0519d99d3d07c292b1c7901219d354b95428d9838d05664ad667fb18"
    sha256 cellar: :any, arm64_linux:       "1ccb9bd4ccaeef63eaa38c7d9ba14982af9766e81fdc914a3bcf398c24fb116b"
    sha256 cellar: :any, x86_64_linux:      "14ca8d082d0d4a98b49396042435bf770a1822d45bd10d76af720232a563e117"
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
 
