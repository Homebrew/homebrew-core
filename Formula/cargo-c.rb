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
    sha256 cellar: :any,                 arm64_ventura:  "04e65e30c844ef254637b26e04c58ccd0970991e79bc43badc5efd90c9099be2"
    sha256 cellar: :any,                 arm64_monterey: "b85903251bc13301b8f042f7ad02ec6396906b6cdf428d947c2ec3d3f0016e7a"
    sha256 cellar: :any,                 arm64_big_sur:  "3dfbc10543193678c1d7feef393e7bd47035fafd8fed3d5ed65d82060c3f4614"
    sha256 cellar: :any,                 ventura:        "5b7fffccc3c013477f70e777045e01f268e6db472aefc8e4d87e0f9c3a3ce355"
    sha256 cellar: :any,                 monterey:       "ca792b2e58e1b9af8fdb40b711e815eb8ca8c6255bd1356ea094f7ff77af48b1"
    sha256 cellar: :any,                 big_sur:        "a40f1e7de26be164dffc81b6b36f247ce5db28447d3c95e5dc27ef5988e8b307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b2ad8aca8c89c6ed6fffa5bb30841669f592eb6efd5591d20610db6b75fa23b"
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
