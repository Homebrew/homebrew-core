class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "10c86ca7585852ce288a44608ef87c827f4b733a94eb847ab15735b823b30560"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5235c556554c2eb6def794df2e685aef958a2fc8a1065d3633a14f1e8b15f167"
    sha256 cellar: :any,                 arm64_ventura:  "6107b6be4adadbcebb57c48a1e2d0a9db7ee59c3c88ffff9a26291464015ec86"
    sha256 cellar: :any,                 arm64_monterey: "27a9d9bd285690b75e28929ad7fcbc4c823d1d4edafce07472795401c5db95bf"
    sha256 cellar: :any,                 arm64_big_sur:  "96f7883d97ab6de68eaf0cda9deecf920754bf438c21ab920da63def1379d786"
    sha256 cellar: :any,                 sonoma:         "0285b7a2772bc5f346319ae2bfb68d685a0e47bb5b08856f70ce757eb61edea0"
    sha256 cellar: :any,                 ventura:        "ce20a66b7219a80617ad20042284afd4eaa8608f90084ca854701fb31e68c7e7"
    sha256 cellar: :any,                 monterey:       "78be6fc5df8d7ae8d3926a0bb1497ac26db866acb84ddb0974dfb73632fe6018"
    sha256 cellar: :any,                 big_sur:        "1be9c417a263a035c124020a65786c495b2219d664d4bd18d0a7b0d850c37a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79df633b377c8c2fd2ba9f73ee41ca825f7158688d8a378110f56625c712775d"
  end

  # `cargo-edit` uses the API of older crates-index that requires older git2/libgit2.
  # So it would need something like https://github.com/killercup/cargo-edit/pull/870
  # at minimum before being able to try updating to newer git2.
  #
  # However, it seems upstream is working on killing off `cargo-edit`:
  # * https://internals.rust-lang.org/t/feedback-on-cargo-upgrade-to-prepare-it-for-merging/17101
  # * https://github.com/killercup/cargo-edit/issues/864#issuecomment-1645735265
  deprecate! date: "2024-04-11", because: "uses deprecated `libgit2@1.6`"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/killercup/cargo-edit/blob/v#{version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Migrate to the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"
  depends_on "openssl@3"

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Read the default flags from `Cargo.toml` so we can remove the `vendored-libgit2` feature.
    cargo_toml = (buildpath/"Cargo.toml").read
    cargo_option_regex = /default\s*=\s*(\[.+?\])/m
    cargo_options = JSON.parse(cargo_toml[cargo_option_regex, 1].sub(",\n]", "]"))
    cargo_options.delete("vendored-libgit2")
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"

    # We use the `features` flags to disable vendored `libgit2` but enable all other defaults.
    # We do this since there is no way to disable a specific default feature with `cargo`.
    # https://github.com/rust-lang/cargo/issues/3126
    system "cargo", "install", "--no-default-features", "--features", cargo_options.join(","), *std_cargo_args
  end

  # TODO: Add this method to `brew`.
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
        clap = "2"
      EOS

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system "cargo", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end

    [
      Formula["libgit2@1.6"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-upgrade", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
