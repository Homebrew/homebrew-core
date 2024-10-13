class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "3382f6c3eca404695885e79babfce6448124a481a77cec11c3bfeb5830f677c1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "172ec9cfe729bbb51b75faf784dac0747fd4a43de01de4a95cb12a3e084af37a"
    sha256 cellar: :any,                 arm64_sonoma:   "12ea428e0307c68840de2f48e93dead7cc0dc64d3ce7232733049710bb6156a8"
    sha256 cellar: :any,                 arm64_ventura:  "0e87dee5ea183f76360d4c8bbc511926e7ce256c4d59966897a67cf88113bc01"
    sha256 cellar: :any,                 arm64_monterey: "5d1f2858d8ce6b55c88cee5baa9ac9f5b060c88639b999418c5835b3a2c00a20"
    sha256 cellar: :any,                 sonoma:         "6714b6ad00bd4d393d6fd5b2dac6179cc50f8d025939c261b7547f59f856b64c"
    sha256 cellar: :any,                 ventura:        "15ef259844d5b8d47f7f6ea6d1afc3c0f9057f938c1b8b8f0eb7416ada2e1141"
    sha256 cellar: :any,                 monterey:       "3af3da222efafdebc1df3ae960f16ae379ce715aaa53af0453ea514328b4e824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d61baee354fd6c7484812b3b5b6d4b1fef2b09885a8ad1328535bc6695387ccb"
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
