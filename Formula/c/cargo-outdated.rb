class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  # We use crates.io url since the corresponding GitHub tag is missing. This is the latest
  # release as the official installation method of `cargo install --locked cargo-outdated`
  # pulls same source from crates.io. v0.15.0+ is needed to avoid an older unsupported libgit2.
  # We can switch back to GitHub releases when upstream decides to upload.
  # Issue ref: https://github.com/kbknapp/cargo-outdated/issues/388
  url "https://static.crates.io/crates/cargo-outdated/cargo-outdated-0.16.0.crate"
  sha256 "965d39dfcc7afd39a0f2b01e282525fc2211f6e8acc85f1ee27f704420930678"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6049f49c035ed7bb3e593d48821239c93b03643ef60aacb847d86db52037c8a0"
    sha256 cellar: :any,                 arm64_sonoma:  "d702cdb138bab9eb25da3782caaeaad6702bc604e0f99551472ac0b926557d87"
    sha256 cellar: :any,                 arm64_ventura: "1060e9672f0ced9f9e2f62f3140c79a9561062ab24439a3c1ea669244bf323a6"
    sha256 cellar: :any,                 sonoma:        "61985936a86ff5a4848bd6fe7c9fec1346065ec0ef16dad3ae6b880a86cd50cc"
    sha256 cellar: :any,                 ventura:       "aea8615845515169d44ee3cbdb4cc8b29b591a0530f5142a8eaef64ee1bf5fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23c83b573ccf7c64e862557f2bd62a398476ee426fb91826746f68114f0335ee"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2@1.8" # needs https://github.com/rust-lang/git2-rs/issues/1109 to support libgit2 1.9
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
      Formula["libgit2@1.8"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
