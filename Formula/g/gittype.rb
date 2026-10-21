class Gittype < Formula
  desc "CLI code-typing game that turns your source code into typing challenges"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://github.com/unhappychoice/gittype/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "49d734b079854549380e4048ac1894112736c5b8fb848957ab1e2d3d6cd4a534"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "122447327d07cc327fbdc1a1a65759d7cfb75c4558d692294f6c001281afbe38"
    sha256 cellar: :any, arm64_tahoe:       "f89a171940d97deefdc9e419e680d517bef0c0639bd0e32e7f5bb473d37bc0ac"
    sha256 cellar: :any, arm64_sequoia:     "f5d43b31ca93b2671a26963ebf5f14c3aede6657d04cfe8f4553c7514a25cc2f"
    sha256 cellar: :any, arm64_linux:       "659e7ce53d7a96d7f17e2944ac34820e35b50a42f433e7ed0c2a38b33c2f7238"
    sha256 cellar: :any, x86_64_linux:      "36a12d7085ae171a3130b5790fb243bcf20becb439f9a3119f7c24c299c0d75b"
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
