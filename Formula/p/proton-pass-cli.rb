class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://github.com/protonpass/pass-cli/archive/refs/tags/2.7.1.tar.gz"
  sha256 "a413bbac7d7b77e8cc465fad26aa8aed3407e48e9b8e96a903100fffc6434d94"
  license "GPL-3.0-or-later"

  bottle do
    manifest_sha256 "ed973a16dc05069a9f4b460124e61d8fb5e3a6766fca17013ccf8bc8a0e71dc2"
    sha256 cellar: :any, arm64_golden_gate: "9722b3c2220a846359afd70eb10af4aef10c92175a2043050bbf0963d24cef4b"
    sha256 cellar: :any, arm64_tahoe:       "c70c438d5ad8347833a08a3ffb43c79367a51dd5b7432475dd03f9d5fc7b5ad2"
    sha256 cellar: :any, arm64_sequoia:     "1ed571b53bda14fb37e9444cdffcfd6bade098deaa523ddd3b004086ef2a464c"
    sha256 cellar: :any, arm64_linux:       "a04eb7d2cc00aa7de2b207f6e1a2b37060cfd409f307c17043fa21db45761f15"
    sha256 cellar: :any, x86_64_linux:      "d4e51ea915808145242d9c13580ba0dffd53d159f55fdd5d73b7625d9c10b433"
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
 
