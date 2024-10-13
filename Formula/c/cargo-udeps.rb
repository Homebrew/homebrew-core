class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.50.tar.gz"
  sha256 "e06e0f735e4d966693be51abe3421ce3fd05459002e03ba85f474f1f5be24823"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "39e4fdee0996d01225194b344dd7f8985a1a61fe3e5064bcb2395c4716227b14"
    sha256 cellar: :any,                 arm64_sonoma:   "ff6fe7b0b7dd42ba7242cbb656cb0a30c0dbe7fe08c632c2f3ef7e5635c219d2"
    sha256 cellar: :any,                 arm64_ventura:  "22ee1a8517c86e233eb581a246a1dddee5382bc18f58b70d23d0a57115268e9c"
    sha256 cellar: :any,                 arm64_monterey: "ab599874702f48a34cf64b05b573a0b8ed5264526ba29291db6d9f119ccb9712"
    sha256 cellar: :any,                 sonoma:         "7a72b74218eeb222426c56ed52ccf1efa6c7250fa19ea408002fe23ab06c93d4"
    sha256 cellar: :any,                 ventura:        "98466772166292d1c0327c8b9b1712b4f5b97d57383bf37b6149a19d549ce384"
    sha256 cellar: :any,                 monterey:       "815c4d0d59392b5fb469617706b3e81b013b08fd378fc9e69b980660a3a36ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfbc1ac3a110359a52a4ac5968633547c765582adcee37ce485ba21ae62c32a9"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2@1.7"
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
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
      Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
