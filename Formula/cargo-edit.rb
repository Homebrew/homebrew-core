class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.12.0.tar.gz"
  sha256 "a8168ea2320c095f55d2b32f8bede8c814dcdc4290c250df36dc8ce0f6fb2095"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b9a73c04042c12385874a754ed0dc27edd910fa2020106e511ebf85b5444f054"
    sha256 cellar: :any,                 arm64_monterey: "391f47c36ef90e3987a34f1caedf4abd375f2f5ff063103c4a756e6b04b675af"
    sha256 cellar: :any,                 arm64_big_sur:  "850f013bbdcbd4961fe9a46e482e77449f87f1aec4e19020dfb7c4f441f13298"
    sha256 cellar: :any,                 ventura:        "a88faf0472e1e1e6a6c87fb39fa70f262445e44c64e5d1325225428f2095a9d0"
    sha256 cellar: :any,                 monterey:       "7f93c359cacbf75c3701687fc66f56e31750b11870b66735357c967852237338"
    sha256 cellar: :any,                 big_sur:        "3cf320b4d339e51f1cd8c27899bf2f38a3456ab88a829a369774692c2bfe71d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "472cdb9afaa0d0b1024776002026d7deb71d280bbdba3a3856cf9356efbd5bf2"
  end

  depends_on "pkg-config" => :build
  depends_on "libgit2"
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

      system "cargo", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-upgrade", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
