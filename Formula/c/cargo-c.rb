class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.32.tar.gz"
  sha256 "a96f3cc6c63d9901c9583083338d50b0132504bb067f68accc17f4116ed01f72"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46900c9ec0a8ef1e2a8da7df55614f6ac5be574e5722b237ee9be2a21b1d7381"
    sha256 cellar: :any,                 arm64_ventura:  "be40d7452b4f50767ebcc9ab96c40422ffce04361785caa811f7d992efb724da"
    sha256 cellar: :any,                 arm64_monterey: "c2a271c072ef4c0810821343c84a4712f0ede1493c399defa367fd5df0e29562"
    sha256 cellar: :any,                 sonoma:         "5902527aefdb710e3b51165d19b3d6510295c02720e639ec271fad5c67310563"
    sha256 cellar: :any,                 ventura:        "e9ef8ea2093f40d0cdb1531e628fb4f975af945bae3b60e93253922756d1c0b1"
    sha256 cellar: :any,                 monterey:       "de2506fbe218ac9b7a18b38213ec3976bc75af04eeefa68406fb70636239e5af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f205ac78bd5b3a9c9de1e9b234781a8b13f99ebed0cccf8e8bcdfd3705db6a0"
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
