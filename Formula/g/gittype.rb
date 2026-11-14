class Gittype < Formula
  desc "CLI code-typing game that turns your source code into typing challenges"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://github.com/unhappychoice/gittype/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "2b9930fd295842ab753e56fe39a544cb2fbc00afe631b749795960b8ad6d888e"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d562588edff078de1bb355d44ffe28c6f684aad9ba81acfef8bed5bfcf0dbef7"
    sha256 cellar: :any, arm64_tahoe:       "d72b8d80bc36127e2eadaa91f32febb6e01c1e60bc7ba1fba59742fd93c508d9"
    sha256 cellar: :any, arm64_sequoia:     "d92c5b3d01a2b6407ce4b5061c29272f20e43e6e1f1d931216a0d283d36487b1"
    sha256 cellar: :any, arm64_linux:       "e9de05b472bd883053e7b6fdf6c72872f288c8726926e3d6ae1b7daf5ee9ab71"
    sha256 cellar: :any, x86_64_linux:      "2d3e7921fbfa069389f726fb04de18f0bc105d3d768877db4dc646663fa2300d"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `cargo update --precise 0.9.114 openssl-sys` for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    # TODO: Remove when Rust's trait solver no longer hangs compiling the Shaku module.
    # https://github.com/rust-lang/rust/issues/151723
    # Upstream uses Rust 1.98.1: https://github.com/unhappychoice/gittype/commit/eed13acb1520925f46ff118f2e401b82d3e40cbe
    ENV["RUSTC_BOOTSTRAP"] = "1"
    ENV.append "RUSTFLAGS", "-Znext-solver=no"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gittype --version")

    %w[history stats export].each do |cmd|
      output = shell_output("#{bin}/gittype #{cmd} 2>&1", 1)
      assert_match "command is not yet implemented", output
    end

    output = shell_output("#{bin}/gittype repo list 2>&1", 1)
    assert_match "Error: Terminal error: Not running in a terminal environment", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 692a8d3..358932b 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2173,9 +2173,9 @@ dependencies = [
 
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
