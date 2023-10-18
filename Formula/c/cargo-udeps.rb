class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.43.tar.gz"
  sha256 "d2c286f696f1d1314fcbef03ffa3c1a365992021529ead1caf533cbe92c3deb9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ca5496ce19b0329b03d7274b377af1da73b2fe5b0d201c96fc65daa1d662943"
    sha256 cellar: :any,                 arm64_ventura:  "b864fe0420a9792bc5bee52698c4dac705cd5b1ca3d2d4baea3a9b334f585822"
    sha256 cellar: :any,                 arm64_monterey: "7e2896fbc47a15d4a9cd5fd8cdca154a865fc2674d544c0ebf4211e021fc24c3"
    sha256 cellar: :any,                 sonoma:         "ef710e4a9173c3be562d9c0b6175b50a43c83783aed681e30338d6d3733e4610"
    sha256 cellar: :any,                 ventura:        "cd2f80e3a72d3043f48f54c77cb59f390b62a348d4db9a5aef244103349e8301"
    sha256 cellar: :any,                 monterey:       "5cb709be845c9c28dfff0c4fb98a783c9e64e02158c7033c6846bc39112673a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2e0ea3df0a9988e6870fb112d880c0f2e56f3ac3d9837f079c041ebd4caf58c"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/est31/cargo-udeps/blob/v#{version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Migrate to the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args
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
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "3"
      EOS

      output = shell_output("cargo udeps 2>&1", 101)
      # `cargo udeps` can be installed on Rust stable, but only runs with cargo with `cargo +nightly udeps`
      assert_match "error: the option `Z` is only accepted on the nightly compiler", output
    end

    [
      Formula["libgit2@1.6"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
