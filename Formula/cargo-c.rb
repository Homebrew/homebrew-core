class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.20.tar.gz"
  sha256 "6a89125c4b59279e73f977ef8a7aa5d83240bdf5d1d7ef1a53b8d1f2201a5f41"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8e34b2febb300f87f9a07ffeb2ef4d9541f89a87991666c62e340eaa482dd3d"
    sha256 cellar: :any,                 arm64_monterey: "a8f7dcbc7f4fe61812aded3f9765ae90eb90657919050eb64554d09c6b767268"
    sha256 cellar: :any,                 arm64_big_sur:  "07f7a3b8bd2b1bf2c3dc02207191f5bacba27c0721c98ac0ac5ffb103569110a"
    sha256 cellar: :any,                 ventura:        "0061c0d06b505709c065ecd6a1c266260edc69f8b799028b68035c7b4191aabc"
    sha256 cellar: :any,                 monterey:       "5ba4129bd88b3cf8b1d309c26b5e7a6ede85bf3b83faeb1fd281a91f0ff09fe2"
    sha256 cellar: :any,                 big_sur:        "689c0f0ae43c65c174c54334e96bb4554ea6a0055e87f67e5a3dee90a1167607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07d32dfc1631f1746f1744b4d0c62f6603c0f20598fe221fd14caa1ab0802181"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
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
