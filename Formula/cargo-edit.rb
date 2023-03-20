class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.9.tar.gz"
  sha256 "46670295e2323fc2f826750cdcfb2692fbdbea87122fe530a07c50c8dba1d3d7"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9c22a6ccac6f359877195172f4ad8cec2659bd9a56ae2be3a7273e9e758e08a4"
    sha256 cellar: :any,                 arm64_monterey: "6d4b42c778413653fa24cbe4b651f91a44ae9e6d8d48515f07a7cd8e54d2fc61"
    sha256 cellar: :any,                 arm64_big_sur:  "37283b757ead9ea8b1fdc3d98e129396897e247a6a47e98cf6e276e1ce7a3b2e"
    sha256 cellar: :any,                 ventura:        "3aca38c8a12b90b09b1a7daf78f51272ce12f668bee134d27e67f38deea347e1"
    sha256 cellar: :any,                 monterey:       "fc16a6785d62b25d3b940084ff4ae44cee2cd3c69bd62b2782e29a08765a7dd8"
    sha256 cellar: :any,                 big_sur:        "84f840e55f103757c1587f066ab306084d3ae639fe27202896ad496194dae7f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6a11b52c1c6f8e5ae500a17cd428e249554ceed7a647f156ce89ae5b4659ca"
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
