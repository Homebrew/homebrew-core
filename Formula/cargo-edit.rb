class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.9.tar.gz"
  sha256 "46670295e2323fc2f826750cdcfb2692fbdbea87122fe530a07c50c8dba1d3d7"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e5f210cbdb4f7eafedaa0b95a9077c349bd436e78c06bc93b2fcd38190b18899"
    sha256 cellar: :any,                 arm64_monterey: "7c84412a22ba4ed5998266ebc0a327c1aa5bc17144a7143192a7633e2afaf08f"
    sha256 cellar: :any,                 arm64_big_sur:  "ff33b50d4c5f74e4081858e58f66584659cd9f26f0596ea65ba95afcbfa27314"
    sha256 cellar: :any,                 ventura:        "f1e40953b55e65681dbd8f715f11aea347abc28e508584f178fcea34ee1f095d"
    sha256 cellar: :any,                 monterey:       "2702c6bca7fc409523feed508e38eba9e547a38eee6aa8f3b16a48c17c1bbd5c"
    sha256 cellar: :any,                 big_sur:        "d488802caa5125e850703c08a60e1ed21f4cf7933d70dcc0eba603911177661f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a05711708df0bc40a742acae5d517bc21d4bf1c5be3fd0b32ec05a7b58f8b3a"
  end

  depends_on "pkg-config" => :build
  depends_on "libgit2@1.5"
  depends_on "openssl@1.1"
  depends_on "rust" # uses `cargo` at runtime

  def install
    # Ensure the declared `openssl@1.1` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Read the default flags from `Cargo.toml` so we can remove the `vendored-libgit2` feature.
    cargo_toml = (buildpath/"Cargo.toml").read
    cargo_option_regex = /default\s*=\s*(\[.+?\])/m
    cargo_options = JSON.parse(cargo_toml[cargo_option_regex, 1].sub(",\n]", "]"))
    cargo_options.delete("vendored-libgit2")

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

      system bin/"cargo-rm", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end

    [
      Formula["libgit2@1.5"].opt_lib/shared_library("libgit2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-upgrade", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
