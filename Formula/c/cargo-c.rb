class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.30.tar.gz"
  sha256 "174cfc3a69263c3e54b95e00c4bd61b13377f7f72d4bf60aa714fd9e7ed3849c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a2837b12c065f002c044c937fdcb4f02d4a0c9a93b2bb0a101469d6aaafed35"
    sha256 cellar: :any,                 arm64_ventura:  "e5313f6b90bcfc806c0f8b85bf515b084936cb8503cd87c490293f3deb1aa837"
    sha256 cellar: :any,                 arm64_monterey: "c129bf4d4a165f96bb141aedc4a7cace29adccc350d715e3c4b7d444b7d64d7c"
    sha256 cellar: :any,                 sonoma:         "68fe9151e11c66338632e60f96625688df90b071c6a6d40d6af91dd47f6d5b5a"
    sha256 cellar: :any,                 ventura:        "81e172c3c357496efde2e3f476608eb2629aae32a2a6cfc45fca385e285b1ef4"
    sha256 cellar: :any,                 monterey:       "97d8418325e74c3da855fe4040860b4ab086e9e66ae29f651f4f0323bb3cb2e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba8e2e1b1f2a8a8d109c14bbaa3d8aafde43a34d94f90502d8f51028ebfafe6"
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
