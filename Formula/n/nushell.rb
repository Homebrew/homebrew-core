class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  license "MIT"
  revision 2
  head "https://github.com/nushell/nushell.git", branch: "main"

  stable do
    url "https://github.com/nushell/nushell/archive/refs/tags/0.101.0.tar.gz"
    sha256 "43e4a123e86f0fb4754e40d0e2962b69a04f8c2d58470f47cb9be81daabab347"

    # libgit2 1.9 build patch
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a25a1d727d750e850bc21be58a35ed017d1295dbbde66d1bf571c7e6b94b216c"
    sha256 cellar: :any,                 arm64_sonoma:  "93bb51e8020d2117712274f8970e5aed7c9091d17e87678ef9511f5cf3f8ca44"
    sha256 cellar: :any,                 arm64_ventura: "80612bc90412f28b96056e3081ea1f2bf0dd2ef515572729ca05834561287cdd"
    sha256 cellar: :any,                 sonoma:        "0aaf21248af61048b45a7d5b7d97e10f4989e7a13b12e9cf451007fc34ed4bb8"
    sha256 cellar: :any,                 ventura:       "7af7cce0e2dbba3a6c41592a0cd2f2f8f83fa7040ac8fbb2454e5609c3aabfe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad018dbb49364c9fbe462c267b7c626a47a8307068da49a3d34e36b1fc85cc48"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 0398b71..9d6021a 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1865,9 +1865,9 @@ checksum = "07e28edb80900c19c28f1072f2e8aeca7fa06b23cd4169cefe1af5aa3260783f"

 [[package]]
 name = "git2"
-version = "0.19.0"
+version = "0.20.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b903b73e45dc0c6c596f2d37eccece7c1c8bb6e4407b001096387c63d0d93724"
+checksum = "3fda788993cc341f69012feba8bf45c0ba4f3291fcc08e214b4d5a7332d88aff"
 dependencies = [
  "bitflags 2.6.0",
  "libc",
@@ -2600,9 +2600,9 @@ dependencies = [

 [[package]]
 name = "libgit2-sys"
-version = "0.17.0+1.8.1"
+version = "0.18.0+1.9.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "10472326a8a6477c3c20a64547b0059e4b0d086869eee31e6d7da728a8eb7224"
+checksum = "e1a117465e7e1597e8febea8bb0c410f1c7fb93b1e1cddf34363f8390367ffec"
 dependencies = [
  "cc",
  "libc",
diff --git a/crates/nu_plugin_gstat/Cargo.toml b/crates/nu_plugin_gstat/Cargo.toml
index 3255936..f9d8767 100644
--- a/crates/nu_plugin_gstat/Cargo.toml
+++ b/crates/nu_plugin_gstat/Cargo.toml
@@ -19,4 +19,4 @@ bench = false
 nu-plugin = { path = "../nu-plugin", version = "0.101.0" }
 nu-protocol = { path = "../nu-protocol", version = "0.101.0" }

-git2 = "0.19"
\ No newline at end of file
+git2 = "0.20"
\ No newline at end of file
