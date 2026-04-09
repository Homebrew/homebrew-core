class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.60.tar.gz"
  sha256 "b1eab01d1fd525db7e8e8b9b843a6a2cc2ddb55450ffef97dcbddeae8d401b0a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b0f1babf90db0b6d472b3d54b4229ab27d4d477bcace4e3e72f0a6ad1a745236"
    sha256 cellar: :any,                 arm64_sequoia: "c51d8d744d30586fb471b970924f89b0ef6f002beeead0f6f41c5b156ea347ee"
    sha256 cellar: :any,                 arm64_sonoma:  "a474e7998c6f90ad63a4b3fcda20db6f183c1a0bf5faa8ff5aaa198447ba5516"
    sha256 cellar: :any,                 sonoma:        "d28ca37096bf81553f948de03994f7bface8758ff248163c9d58fd3d307a1684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f5206f7c22a18f322ebc4eea01b96e509d4831eca1cad867525b2aa06d45082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d5767124eb006fd03faf9a346c96d88fd69edecabe53715939402b9c0ad24fd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
