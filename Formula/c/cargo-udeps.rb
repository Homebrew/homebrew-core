class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.42.tar.gz"
  sha256 "b89c4ba44112a5b9d544bc8555a69f2fa24f44a0a389035cd38f19827a262e78"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "335521a382d7248d69e7bac2847385ef3a0dba0fc1e4da6eb1e45b28786c22c1"
    sha256 cellar: :any,                 arm64_monterey: "be671c1ebb5ad02fb333b5c813a343969a8993f507c2cd3050481277d5258843"
    sha256 cellar: :any,                 arm64_big_sur:  "04e54885fdb7a726858ee267bb7ebfbd9a141b6b5f275fd2c8c36c7df3ac3ffb"
    sha256 cellar: :any,                 ventura:        "93a73f0049ad92f308ee8a0473580a0756f60cffb4365032d7c0743a8cb11e43"
    sha256 cellar: :any,                 monterey:       "ca9c4e79c2f41acb75219cc3e936cc38f32b7f94d3b360e9df7ba235318e63dd"
    sha256 cellar: :any,                 big_sur:        "2f471ecb6d65e02479ec193e1398bd4d18f350d0f1d383d045c6419097856621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2453904dc8a8b9593261d08d5f9e02fca70daefc8af80faf3a9cf2bfb5d7e43e"
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
