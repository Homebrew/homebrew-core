class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.61.tar.gz"
  sha256 "c50b60817cf112fb8cfd4272bbdd3c342947c72aeb60435c87d45d197da96e77"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d80af82efdf3c7b06fe4189fe09664b955848c83077d346f1ffb4eeff7f8e9a3"
    sha256 cellar: :any,                 arm64_sequoia: "466209aa6ba61edccb693f540fb5a7b6a3774cd172f3b6eabd894553db1bc226"
    sha256 cellar: :any,                 arm64_sonoma:  "dd3340af06b1d5ffc42d139e49257b1ac00665a8e75b3b7245252a2e52d4383b"
    sha256 cellar: :any,                 sonoma:        "f272485e3f56b147e1c68e07d8fd7fd91b06e343cc4250b84cb9ebaae0e63296"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d3bcca123df90077cf852de6ef808c2c28135a13a5b643d48d930457a5e199c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d30eb29b6cde34d57f10a502b565bd6bc9baabcb569f0341974060cc8c252f7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", "--no-default-features", *std_cargo_args
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
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "3"
      TOML

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
      assert Utils.binary_linked_to_library?(bin/"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
