class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "922171afb3ceaf6553ff3916ae4663d3743ba22f80725f2300a26b76eb6eb94f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b7185684a104169982511f59d5551f5647736f0543e5b6d9386b22da08643b90"
    sha256 cellar: :any,                 arm64_ventura:  "0cf7db1a3320601f1a140953069c4b79714b80095d78b3465b0005e627da0d79"
    sha256 cellar: :any,                 arm64_monterey: "04e5e4b5ba0f4951c233b5730f33c0849585f05b0e3c38142e59e77bea4907a8"
    sha256 cellar: :any,                 sonoma:         "faa2930ea57e6c3ac22746a4271a463e1180a001af0e4a8a8224c7efab0e2f9b"
    sha256 cellar: :any,                 ventura:        "3842f77fe03491c52c029539282d1deae58fe07c4e710b644e8beec0c1f7350d"
    sha256 cellar: :any,                 monterey:       "ba1f217eae0e553e42805fce58b91e340f456beaf5892bc4c5fd7d6bb853c944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1a338df719a904741bae73400bdf2d05ff43e88e2e1ef4148328f85abc0883b"
  end

  depends_on "rust" => :build
  # The `cargo` crate requires http2, which `curl-config` from macOS reports to
  # be missing despite its presence.
  # Try switching to `uses_from_macos` when that's resolved.
  depends_on "curl"
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
      Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
