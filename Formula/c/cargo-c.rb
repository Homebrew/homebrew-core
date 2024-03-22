class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.31.tar.gz"
  sha256 "4a04db8fb17a55db403bc59572f05475a477fece7ab08cfb2de970e188b80b83"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5e5909e287015119435bffcb6feb304be6363ac14b0e49df4f8ae2aeb51cf24"
    sha256 cellar: :any,                 arm64_ventura:  "006dc5b7386ab642a9a138d57a7408f5b4d546d23b11f9635a0db1761b1dd43c"
    sha256 cellar: :any,                 arm64_monterey: "edb295ec26dcf230f048a063d473861aeaedd3412ab557679ca64610b34fe36d"
    sha256 cellar: :any,                 sonoma:         "63e105d89f49d294e58fb3ef245ee125c1335b680c01b4553c4382b149c67032"
    sha256 cellar: :any,                 ventura:        "4a7a6631fb0fc4cabf5ca3757b45bdf4a283e404b6a0e51b735c0efb4d2e3ffe"
    sha256 cellar: :any,                 monterey:       "7fbd4040b98f8ae9abd54c8577fa0c4fa351ee91c10560711dd58dee8956c937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "960f06354ea0d82e8b9a7c82269f7120c5a272c3b6e03f7bd3f60b9bc1606eeb"
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
