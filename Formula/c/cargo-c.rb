class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.27.tar.gz"
  sha256 "caca521e893ae7cc63a9e2c5e58f2151b7b74754a4fd884c8eb5939b967ae0d5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d5b45ad1f0799931240b3d9a9a35aa21f6c725c6c365dd777c470904320ca92"
    sha256 cellar: :any,                 arm64_ventura:  "19e03ef68e7e6b9feb388d77ea13b54e3d018f7c51cdc361a7a01f88377a8f88"
    sha256 cellar: :any,                 arm64_monterey: "beea981032d72857ef8adf8e1303652d1ad22d16887f59f99638d57dc184a3c8"
    sha256 cellar: :any,                 sonoma:         "c98074ce586eac3a305e77e06a053815af01b11319436200d71abb568fd7c649"
    sha256 cellar: :any,                 ventura:        "a1338524f461aa2333973e50ecccbe8794571a8a304b31bb25047fbc4cddfaf3"
    sha256 cellar: :any,                 monterey:       "431a1f05fa02b241e99f59b2088aae0af9adfa20ac6e3bd2cdbcd91fc5cbd573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80df81d83864748d81380919eb6c0192a946f69613ae092d3317a4adbe127622"
  end

  depends_on "rust" => :build
  # The `cargo` crate requires http2, which `curl-config` from macOS reports to
  # be missing despite its presence.
  # Try switching to `uses_from_macos` when that's resolved.
  depends_on "curl"
  # To check for `libgit2` version:
  # 1. Check for `cargo` version at https://github.com/lu-zero/cargo-c/blob/v#{version}/Cargo.toml
  # 2. Search for `libgit2-sys` version at https://github.com/rust-lang/cargo/blob/#{cargo_version}/Cargo.lock
  # 3. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Use the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)

    [
      Formula["curl"].opt_lib/shared_library("libcurl"),
      Formula["libgit2@1.6"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
