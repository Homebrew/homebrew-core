class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "85230801f57c1f2b85d99fae3fc43f93080ecc0e3763a6af178fc5e6c218004b"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c42771824ac04b414af6521ecff00f7c0a209efb9a741dcd382acdb0d11b7a49"
    sha256 cellar: :any,                 arm64_ventura:  "76e5e49e05be6cb82ed0ed42eab38c624e52e77adb782cdd83d6201fb0babc29"
    sha256 cellar: :any,                 arm64_monterey: "2a7629159198c93fd1e2b064e8dcc6ec8855cd7cf3b2f7411436c9e17be0818b"
    sha256 cellar: :any,                 sonoma:         "73400d87bcfe1f36f048b6c68eb499e38d0c979193f47cef3954fc61cbb0ce7a"
    sha256 cellar: :any,                 ventura:        "3738e517a4fd6f1793dee3c55aec6f0e5ca726c9996c3a087e230d83a2c70dc1"
    sha256 cellar: :any,                 monterey:       "e4d2406ee10fbf0f006ddc81fe8c1d656aaa3cbc804a712b382a9576983803a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b26ffaa5c517b3c11ece3b2676427c2617b38c435a129472cd1360b32a29fc6"
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
