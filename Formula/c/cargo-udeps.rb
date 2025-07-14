class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.57.tar.gz"
  sha256 "369a1387131ca0548d9bd14fe9d344a8ea217d7a6df2343db6fbdf21a8b94dea"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "288551b8c1acff4faaf2f8950b60d9de83e2a6f5643b4bb63ef3689c60f7d029"
    sha256 cellar: :any,                 arm64_sonoma:  "d16e797594750fb8bd1ad1afc2a49901bea1c48587bef487c2155cb8192c4875"
    sha256 cellar: :any,                 arm64_ventura: "367123823b4ca2e1bef335e576a33e24926ec638991bafca9144ab4917be0017"
    sha256 cellar: :any,                 sonoma:        "5e3bfe32151d99bf0dc38f92ebba11452e225269faf7ffcc110b1597aaf72d4c"
    sha256 cellar: :any,                 ventura:       "da6af4ba4cc045091613a44c346e625977ffc18ae16358e58de46c87260d9d40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce72a837695ac3d74564b1f7d372f717b65deffa5c69301a4d3d0b74eae59e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4708ce7778d28d320595eccb0c1e1c7184522a03fb66f1e16e3a0f6769eccdd0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "3"
      TOML

      output = shell_output("cargo udeps 2>&1", 101)
      # `cargo udeps` can be installed on Rust stable, but only runs with cargo with `cargo +nightly udeps`
      assert_match "error: the option `Z` is only accepted on the nightly compiler", output
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
