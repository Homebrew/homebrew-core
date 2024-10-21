class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "3f131a6a647851a617a87daaaf777a9e50817957be0af29806615613e98efc8a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9c0c1b7844fe4712d74500fab1032405414930b4bba5abed3881a189701bed1a"
    sha256 cellar: :any,                 arm64_sonoma:  "603a4e4b165a5eb5d7f4f52f7de4c0b583345eb6789a7c9a43aa358d486560b0"
    sha256 cellar: :any,                 arm64_ventura: "ca357671b2b7d8df05e2e248eda1943ebc666e0ed1a36d8e500d729d6de64d68"
    sha256 cellar: :any,                 sonoma:        "7a5eb6a052715f2bf19afce583456cfbf42747c8b1f1ca2f5c0cc1c0ae9ae888"
    sha256 cellar: :any,                 ventura:       "2c4591df9bdfa9fa55d83d3cc4727a094e375c161bec9b7dbd4b7c137a01b68b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1b17b13927c04926fc5a6e0acf59db403d80c57aff93f8b54243ab0da83c0c8"
  end

  depends_on "rust" => :build
  # The `cargo` crate requires http2, which `curl-config` from macOS reports to
  # be missing despite its presence.
  # Try switching to `uses_from_macos` when that's resolved.
  depends_on "curl"
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
