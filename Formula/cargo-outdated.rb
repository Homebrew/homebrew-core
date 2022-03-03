class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.11.0.tar.gz"
  sha256 "203504d8f7aa6ba633e256b6f9d81162dd1f3ddbf92934ff689060ae80b6b203"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f80039197a8a9d8f8e876ad5509307b689edbe0c00a2aafbe46ff590beb8feef"
    sha256 cellar: :any,                 arm64_big_sur:  "611b0bbb483b79d72954a86674b3f6d4b4e0ac7db44abdc92771493e15c119d2"
    sha256 cellar: :any,                 monterey:       "e27380689ab5bdbfa851492ed3d05af11df17d354864b557b9ff4eba8e54b134"
    sha256 cellar: :any,                 big_sur:        "3c64483d6585739b2ec4eefc71016bd2d66a8e074c831f616b0ac272ae6854ee"
    sha256 cellar: :any,                 catalina:       "3b09391c389cc3abb02a03460beeb1aa1cdce35df55e98c8c2319eefc3ef94f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29491160f0ff4e38fad970d64f63b7b815a4332ff27d70590d531066cbbc5cc5"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust"

  # Workaround to patch cargo dependency tree for libgit2 issue
  # Issue ref: https://github.com/kbknapp/cargo-outdated/issues/307
  # Issue ref: https://github.com/rust-lang/cargo/issues/10446
  # TODO: Remove when issue is fixed and in release
  resource "cargo" do
    url "https://github.com/rust-lang/cargo/archive/0.60.0.tar.gz"
    sha256 "96dfa69407e9c5493c0858aab1d89e8f8bad992ab9ee1f83f2c55f6c7fc3686a"

    patch do
      url "https://github.com/rust-lang/cargo/commit/e756c130cf8b6348278db30bcd882a7f310cf58e.patch?full_index=1"
      sha256 "fc3caa41c01182f62f173543f0230349a23e37af05bed0a34ceb2bb5ce5ab6f7"
    end
  end

  # Fix issue with libgit2 >= 1.4 and git2-rs < 0.14.
  # Issue ref: https://github.com/kbknapp/cargo-outdated/issues/307
  # Issue ref: https://github.com/rust-lang/git2-rs/issues/813
  # TODO: Remove when issue is fixed and in release
  patch :DATA

  def install
    # TODO: Remove locally patched `cargo` when issue is fixed and in release
    (buildpath/"vendor/cargo").install resource("cargo")

    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      EOS

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end
  end
end

__END__
diff --git a/Cargo.toml b/Cargo.toml
index 2ce0c82..a2f5274 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -31,7 +31,7 @@ name = "cargo-outdated"
 anyhow = "1.0"
 cargo = "0.60.0"
 env_logger = "0.9.0"
-git2-curl = "0.14.0"
+git2-curl = "0.15.0"
 semver = "1.0.0"
 serde = {version="1.0.114", features = ["derive"]}
 serde_derive = "1.0.114"
@@ -41,6 +41,9 @@ tempfile = "3"
 toml = "~0.5.0"
 clap = "2.33.3"

+[patch.crates-io]
+cargo = { path = "vendor/cargo" }
+
 [dependencies.termcolor]
 optional = true
 version = "1.0"
