class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.40.tar.gz"
  sha256 "7122f08b9dac152c6dddacd2610aa973807037f2a2f1d9042de4bcf17d344471"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d0b3cc828acc2754e9401af3bdfc1fb0a242984b8368f7084fcb8f1130419fab"
    sha256 cellar: :any,                 arm64_monterey: "04e44994ed20a2aa61fae96695dee995920e58a873b0788552543a98dba71bd6"
    sha256 cellar: :any,                 arm64_big_sur:  "a58c6d706850f30c48f5ac4c308bcdcc5f9ed11fb78929e5edf468c5752647b7"
    sha256 cellar: :any,                 ventura:        "3f883e6b02d9ff04106a772363a934fa0e351a4177de10c6b8fcbbd6dc39efe7"
    sha256 cellar: :any,                 monterey:       "aab5c77f8537b50ae516d596d0cf1a11c80bf45a1f644cf36f9051813a6b0084"
    sha256 cellar: :any,                 big_sur:        "ddb39243b75930a80605cae5c641f3d20d2b77d8b51c35360f0f9de39ceba3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ace49c71362099db010fa3ab3756ec1a6f5b617391e884033da48e798b8e0f"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"
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
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
