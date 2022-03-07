class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.8.tar.gz"
  sha256 "7c649061826e0ad3c2c8735718f4a0c4afd12eed9b9fdc5fe59e34582902e1c5"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4eaf3f9baa7b86d145965549c863852edb96dd912c4eaef79479348733bd5fc0"
    sha256 cellar: :any,                 arm64_big_sur:  "289aed48fcf4e1882d50765c746acd5d76f5b7ac2d82062b2b626d490189c0fc"
    sha256 cellar: :any,                 monterey:       "d4b991d5730d25cbe12153143eab2b85638fcab48664a53a9f4078c908cf3179"
    sha256 cellar: :any,                 big_sur:        "336d17a7a76a35cb36ef451d930cf1397bb8b753882770e61c2cc1de0bfb2035"
    sha256 cellar: :any,                 catalina:       "1076573f2cd24eee139882b151ff9966c5f72e54d2796c109784816633f81f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef52f235d170217052147b35a54381e3eb472221b8ec918ac95fefe52ff4e070"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Workaround to patch cargo dependency tree for libgit2 issue
  # Issue ref: https://github.com/rust-lang/cargo/issues/10446
  # Using .crate as GitHub source tarball results in build failures.
  # TODO: Remove when cargo-c release uses cargo version with fix
  resource "cargo" do
    url "https://static.crates.io/crates/cargo/cargo-0.60.0.crate"
    sha256 "bc194fab2f0394703f2794faeb9fcca34301af33eee96fa943b856028f279a77"
  end

  # Fix issue with libgit2 >= 1.4 and git2-rs < 0.14.
  # Issue ref: https://github.com/rust-lang/git2-rs/issues/813
  # TODO: Remove when release dependency tree uses git2-rs >= 0.14
  patch :DATA

  def install
    # TODO: Remove locally patched `cargo` when issue is fixed and in release
    resource("cargo").stage do
      system "tar", "--strip-components", "1", "-xzvf", "cargo-0.60.0.crate"
      # Cannot directly apply upstream commit since the Cargo.toml is different.
      # Commit ref: https://github.com/rust-lang/cargo/commit/e756c130cf8b6348278db30bcd882a7f310cf58e
      inreplace "Cargo.toml" do |s|
        s.gsub!(/(\.git2\]\nversion) .*/, "\\1 = \"0.14.1\"")
        s.gsub!(/(\.git2-curl\]\nversion) .*/, "\\1 = \"0.15.0\"")
        s.gsub!(/(\.libgit2-sys\]\nversion) .*/, "\\1 = \"0.13.1\"")
      end
      (buildpath/"vendor/cargo").install Dir["*"]
    end

    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end

__END__
diff --git a/Cargo.toml b/Cargo.toml
index c8426f2..d82b2b5 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -43,6 +43,9 @@ cc = "1.0"
 glob = "0.3"
 itertools = "0.10"

+[patch.crates-io]
+cargo = { path = "vendor/cargo" }
+
 [features]
 default = []
 vendored-openssl = ["cargo/vendored-openssl"]
