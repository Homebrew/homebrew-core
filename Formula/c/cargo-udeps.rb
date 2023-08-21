class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.41.tar.gz"
  sha256 "f150a544a8aa5b3f604113a13c6a8fc0e0cf3feecd47c2c015b07b5bf80f6cfb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f767a65e795a26cdc49633b0fad577070b092d772508acd8c6431abc07d984c4"
    sha256 cellar: :any,                 arm64_monterey: "b78eada65256f9056f84aff0fad0d7d2b6a4a5ca9b3674adf797ceac3d2d9bc6"
    sha256 cellar: :any,                 arm64_big_sur:  "086dc47fd4c0171e90006d30d0cb333ea90533f20a2a0c24760051a83a537949"
    sha256 cellar: :any,                 ventura:        "4e46153fd1eb2b0401f8e31ade16a2b60a19a1ea8e0ed8a403cd8467da0f7b0f"
    sha256 cellar: :any,                 monterey:       "4409e567d6c8d8213277829b66b83599c98cc1063652313238de3747fa0f02c3"
    sha256 cellar: :any,                 big_sur:        "e9d0fe88dc1dc9b9ccd0dba199a8b0e581cc6f14e8e974e77dc17198d806fa04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba93926882a6093960395b351970285403b6574b9d04d00e06616a9fb703df15"
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
