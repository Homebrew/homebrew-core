class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.47.tar.gz"
  sha256 "8794b480ab6dd166617711345116be5958def42679c1a5948d41850ecb9cb806"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ae5e7589474a516f6d565b1142afa489013f0f268bd2895f7ea4b6177498559"
    sha256 cellar: :any,                 arm64_ventura:  "ed414168a81895dca159fd8ea4536f02e0f63af0984fac6accd904c6278694a5"
    sha256 cellar: :any,                 arm64_monterey: "b4357283b3e72cd94b2dd5c97a612d0338f3487d3cf6d24c1edd3c030c4a79f7"
    sha256 cellar: :any,                 sonoma:         "ddbf414fc5a595b9d0066cf4d2a601cfd30fe295e02bebb709b6d62b61252d3f"
    sha256 cellar: :any,                 ventura:        "10811480430f9177ee054053d05add9b9ece0a63117a881900ec3320ed422743"
    sha256 cellar: :any,                 monterey:       "590582d3e187fc4520484d56c259b1617994f4a90f37ce972fe0142c5c41d837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "967a60e21585a6b128dff2a2af857f71f570a84c30b59344c22ea9146f5c2b48"
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
    ENV["LIBGIT2_NO_VENDOR"] = "1"
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
