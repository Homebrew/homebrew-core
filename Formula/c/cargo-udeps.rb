class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.59.tar.gz"
  sha256 "255929d3c9d53c3e09e53b38302e68b206b167bc4e10dc69cf7984c0fe1f5814"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "105b0e164ea8f62a30ed017afa00cdbd73ac425150e0590b34733f2cc66ecfab"
    sha256 cellar: :any,                 arm64_sequoia: "e593bd0889697613a7a36c113cd85abfcf7b842d46f5e67f0cdaabdd8c615fa6"
    sha256 cellar: :any,                 arm64_sonoma:  "3c562d088f70891a780743d345b572bb445c02187d80352a5af1e9727bcd6577"
    sha256 cellar: :any,                 sonoma:        "eece9d19ad7c6509777a655e9381b8a10c865ecb5fdd5b71c02ac1b305edebd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ac41605a30d8a759503500ae902e4849e64d7010c9d37557e9e4ac2a3f52c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1ff57ca7e9f1ae32c8b262afcc8ce13361a449240efe65e2b66004314a5bf0c"
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
