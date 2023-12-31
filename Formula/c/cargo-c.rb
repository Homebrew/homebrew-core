class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.29.tar.gz"
  sha256 "a52bb78cf6db00aa1caf06c679cfece27357c84367d8ac167d715e05e5f5a778"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5d91250c050822b93d332993551f78e804e2a874564327a7c69c936715c7262"
    sha256 cellar: :any,                 arm64_ventura:  "ed450315dfbc80634e7778f9e3454287e31a3e8bed985b338353015ce71278b3"
    sha256 cellar: :any,                 arm64_monterey: "f9d3f5abc5f10244bcaad6c0bfe3c2b4a1b61867667b9d689966a8e4c05e6bd5"
    sha256 cellar: :any,                 sonoma:         "ee77a8a84a9d0d686c118cd9593db3fc33d745a5da01e12d3547ad56a3a74b42"
    sha256 cellar: :any,                 ventura:        "bff9ca1670f00db32019913de257db14a636293725db78d6685f8d3312163745"
    sha256 cellar: :any,                 monterey:       "3fde27d596243a617f4716a7c2314af8a5a326fb6d24ba450632899d1b784a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a16633313bb9c3f962e733ad75c40cd78dd31368dd4da52fdc3c81ba85b1243"
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
