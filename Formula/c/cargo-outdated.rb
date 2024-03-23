class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  # We use crates.io url since the corresponding GitHub tag is missing. This is the latest
  # release as the official installation method of `cargo install --locked cargo-outdated`
  # pulls same source from crates.io. v0.15.0+ is needed to avoid an older unsupported libgit2.
  # We can switch back to GitHub releases when upstream decides to upload.
  # Issue ref: https://github.com/kbknapp/cargo-outdated/issues/388
  url "https://static.crates.io/crates/cargo-outdated/cargo-outdated-0.15.0.crate"
  sha256 "0641d14a828fe7dcf73e6df54d31ce19d4def4654d6fa8ec709961e561658a4d"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "54b8148cb931c6ca999ab3b891c1e428c17bcfd6e993b9163dafada1a2d01004"
    sha256 cellar: :any,                 arm64_ventura:  "5f76ae232d514475a9d0906d758b957561c080fd83f54d04eb5645701239ed41"
    sha256 cellar: :any,                 arm64_monterey: "6c74653ea6afd9e98ca426da74f57e8ad902233cf146ab49f95ea4809f08041e"
    sha256 cellar: :any,                 sonoma:         "72267d14d7e9878f92e09b477b467f075e50683c6c7807aa29cafa4f025f2759"
    sha256 cellar: :any,                 ventura:        "faf909de0a869c43a7575f6f0fef829fabfcf47573808909293004644f2e88ef"
    sha256 cellar: :any,                 monterey:       "db0b25256c538e343debeb53cfd9a41bea3bdffd0a2cb25e7975b56c902de1e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b82e36d6db5560fdeb3058d052d9a8cc6bae01f38d58e1c14bc5f9161fa464"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    system "tar", "--strip-components", "1", "-xzvf", "cargo-outdated-#{version}.crate" if build.stable?

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
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      EOS

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
      assert check_binary_linkage(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
