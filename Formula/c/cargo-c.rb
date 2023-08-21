class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.23.tar.gz"
  sha256 "bb6c119d72682095fe05fcb6b6eead33090f3eb6e71950f21b8f51a2013984ad"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "416bdc431d89590538bba39aab93fd6ca4ec4d7a4fafa9640997eee7c274d678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75700e8be8d2f7aaed257a449322984a5507773cbe8a793dd89e139a98e72453"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e15c8bad82a57934e3f0a682834f10879a1c60ca2d7d589d9ea4b1c8fe3d4ca"
    sha256 cellar: :any_skip_relocation, ventura:        "7eea93fb9448760bf955d2d05c79d27e514798fd43dc346e78ffde564c481f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "9da05739890dfc6c328142f7b8c028fccdf54adb86bf48e4343422803efbe427"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fdc70305d9d1ced290aef63ca71082aaaa6ce98863f94a40bfc9b8b2a8c848a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae3ce1f2163882a195120144a796258bd2b498b424e980dea0040fe0639ec08b"
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
