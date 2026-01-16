class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.60.tar.gz"
  sha256 "b1eab01d1fd525db7e8e8b9b843a6a2cc2ddb55450ffef97dcbddeae8d401b0a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de06a7df4d0ba93d12e5ddf1fba9775747ed832cb120e2c8fb6f0e9150fe2a9b"
    sha256 cellar: :any,                 arm64_sequoia: "44aa26bf28330849b92a60c68841ad841a7895abf5ecae539fc486a6839b634d"
    sha256 cellar: :any,                 arm64_sonoma:  "18ea53f3fb4cc6fcd92d0a069c01446919a02c0270d3819cdd6f7880db26cfa2"
    sha256 cellar: :any,                 sonoma:        "21750d58f982ce3f5cdbdb57f943da3ddff3c6634d4770082eccea5d40e33a61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ba6a379fdaec989fcd7960f99d444bbe2262ad0b5b8d4d0407a197405305947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "702abdddc3ad718c5839a631f6ccda126289947ce7fe0785c33f644b6df28b20"
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
