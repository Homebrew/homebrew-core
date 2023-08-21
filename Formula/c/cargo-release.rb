class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.11.tar.gz"
  sha256 "cbbc04f7faadd2202b36401f3ffafc8836fb176062d428d2af195c02a2f9bd58"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "54a485d4a1ae0cfbe02ca03b575bb68ddd73a6a7f7e5b639f2eab137c13ece6c"
    sha256 cellar: :any,                 arm64_monterey: "2284b1c54a8e06dc13949d878249d4523f05f10979b96cb2bb6a839cb4ce4e09"
    sha256 cellar: :any,                 arm64_big_sur:  "7b0308f1484bfd4099fa5e56b43945c7d3fef87acee2674f093207c2c1e12baa"
    sha256 cellar: :any,                 ventura:        "e61342566c8db809bd7d04e77fc7ee5ad5e3c4470bd2ac8c6a47aec022f91da2"
    sha256 cellar: :any,                 monterey:       "96ea8160fb90776cbedd4904599a1778abe84677ed4ceebfd24920ece9375d9b"
    sha256 cellar: :any,                 big_sur:        "d6a31e6614be4c4daf2803cc381b139ae90c71ed260a6dd4e6a943281f45d975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c49772b37f68c2dda8c291b26ae9da61eebc81d582f4dab783e4ac60071341f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
