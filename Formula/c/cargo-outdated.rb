class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "a0acb73eca2cc65915db426e49a0b834d20ef2cb302bd2ce21c1d59f3cb1894b"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7aa16f918979213758af38c2f285cd5805574bbce7bbf2f05652137bd1975ca2"
    sha256 cellar: :any,                 arm64_sequoia: "ab7387ccf1d8ebcd8e4c59c41dea28364316b5d03f99d47f8c4ef812879a2b36"
    sha256 cellar: :any,                 arm64_sonoma:  "e1ca3f3386b589beb3af60ffd8ffe53aa975a273d575066c97281479e1182f59"
    sha256 cellar: :any,                 sonoma:        "d701232c35a2768f0a1a8ac96c68bb16d4aa6353c96725d0339ba467b62fa057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cf595c0dd40841f29b17e81855161d5f03c5998ad482bb5f4ab054d112cdae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dedf4524e646d5747c1061b9c84eac2378dde63de3b3f01c3d618c04496094cf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
