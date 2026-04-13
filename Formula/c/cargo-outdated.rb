class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "a0acb73eca2cc65915db426e49a0b834d20ef2cb302bd2ce21c1d59f3cb1894b"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f8504bf9f925b96d25650f9e54b66ab2b4bdad03152e32852925f91d8ace013f"
    sha256 cellar: :any,                 arm64_sequoia: "1a816f6084a20539490d740967f2904540c7dd3944b6004c0ea03cf4a7fd8792"
    sha256 cellar: :any,                 arm64_sonoma:  "265d75b98895a464a49eb0f48bf3468d871633eb9a82f531109a37e0459305fa"
    sha256 cellar: :any,                 sonoma:        "d2e13f92d39844c992b1027ca25eb291f6d423ba4b99ba2817326057af1df28e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f957cffbd6b076b0b845866372797d8d47af68ae1edb9a7e9bfd899cd07351d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2964bf4703ecdcf66ed3a80c955db9dada8663c959fa28b89057449649ba9cf2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args
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
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      TOML

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
