class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.17.tar.gz"
  sha256 "95fcf50505516dfa6a941e666d1388810da9d7a9e1c623c09068faef5d50b3b9"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "06583c259ff52596d677d6d078177b8332ce5fad390990ee3108f8fba6e9e9f9"
    sha256 cellar: :any,                 arm64_monterey: "be0c8ca9ef2d47c48150f939a877d051f3787d2e87cfbd74731e3204c4d6dc9b"
    sha256 cellar: :any,                 arm64_big_sur:  "605bb7037f3477534a3336ad9726eca9fc3446f954ceb8e246ef2ca88f7227cc"
    sha256 cellar: :any,                 ventura:        "45ac6c9062fc126ecdb9ba842ba20a9ad13a1a9169ae834173c14fd71eb4dc35"
    sha256 cellar: :any,                 monterey:       "e41b15f1bcc06b631d63bd7122c781b65e80bf9ec75cb615ec8d535298aaddf8"
    sha256 cellar: :any,                 big_sur:        "c15d8d1ca92e96e55044953512134c5ad3e4a3bcc53e81b09c7cacd7bb620f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d15aa74f00c90a13d60a4f5e00ff14693ba68bfc83c81228beb7832a81a9608f"
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
