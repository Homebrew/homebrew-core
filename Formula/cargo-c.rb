class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.18.tar.gz"
  sha256 "1839c3e31f19eae346c47dcf2084bda80d875a8bb01fb2c55489802c7793c2d8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8546a13c2d59eb392cde6628a8d212f251f79150296ac4b8ff01766fcf3395e8"
    sha256 cellar: :any,                 arm64_monterey: "1be95270058943f4be4cbad04d0abd2aaaa41773b0ce815c040d44130c89683b"
    sha256 cellar: :any,                 arm64_big_sur:  "f0f7076c0d8c78adbad169212634fc85097b32a93fb561ee0dc04b830c27b860"
    sha256 cellar: :any,                 ventura:        "75af7275cc055a8ac89d75d004c295b4d165cdc7d3e784068b98a6b413daa40d"
    sha256 cellar: :any,                 monterey:       "bf450ecbfc84177b2345d2d6e621029b1e6156f5173e40dda4ed3ff837ef71db"
    sha256 cellar: :any,                 big_sur:        "2e9a81fe9c171a896ff3db7e29623fa3060feb90158b09da7b0e2f017450e177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b256febdb65948575e8493a3c9abbeb5ac70e9b75197767c26198ed91d1146e8"
  end

  depends_on "rust" => :build
  depends_on "libgit2@1.5"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
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
      Formula["libgit2@1.5"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
