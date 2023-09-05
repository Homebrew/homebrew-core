class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.24.tar.gz"
  sha256 "32f2f5c802c01c51cf93471fcf876d0cc68edbc31d22005b9f07e4549d5b98b1"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9d658efff144d6c77c791909b476b9578974b83ca469bb749f243e390ef74af1"
    sha256 cellar: :any,                 arm64_monterey: "1711e72cac37cac5c7b77863d96304d34aadefa1ff1441f053e5322fb8eff55c"
    sha256 cellar: :any,                 arm64_big_sur:  "440b46dc200e275903f4d2a7e6db22d1eab68408cf302d1884c48ede191557d3"
    sha256 cellar: :any,                 ventura:        "eebbbf637a7ead9c515eb2eba92b222b9f031f8c287a1fa182044edb74dcbc7e"
    sha256 cellar: :any,                 monterey:       "dca789527716e9372f4c08bea55241755945e1d9366cef6a9e222a6c40b4cfe4"
    sha256 cellar: :any,                 big_sur:        "3a9e086ea4a0295a81f10a33fd7bd2b0e9be515f353045c01b538469cdfcc5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce54e7d9c93515875873697fb1759885c62e7846b959522a7fbbf649cce7ca57"
  end

  depends_on "rust" => :build
  # To check for `libgit2` version:
  # 1. Check for `cargo` version at https://github.com/lu-zero/cargo-c/blob/v#{version}/Cargo.toml
  # 2. Search for `libgit2-sys` version at https://github.com/rust-lang/cargo/blob/#{cargo_version}/Cargo.lock
  # 3. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Use the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"
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
      Formula["libgit2@1.6"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
