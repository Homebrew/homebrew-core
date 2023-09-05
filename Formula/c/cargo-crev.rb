class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "fc2766dd0c18e3ab24ccbab27b5419eced418b968cf7bbf6260e7afe66bd0fcf"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "948addd888f73c01f8565c3f0d469aa7431816e1d18f0a1629ee38862e68b6f0"
    sha256 cellar: :any,                 arm64_monterey: "773efd930cd69fac0869c8b3a3cc893318be7e77a6c3f06341547b983dee6ffe"
    sha256 cellar: :any,                 arm64_big_sur:  "2f9e2ca476e0d39489516d59a1c7856266cf3c9a6dffb0fe9460236c38c7a9b0"
    sha256 cellar: :any,                 ventura:        "fc877dac5fd91acff9b4a03f5416a6665874aed8f35884ed8b9888d8ea1b9e7f"
    sha256 cellar: :any,                 monterey:       "4ec702e04ff193c6b187d451273fc2bcf42547bd1db21d978fac48aca63fb847"
    sha256 cellar: :any,                 big_sur:        "58d8003d94170d361a8b74fef2a4afce12b1464b3965dc57388ea1aff2d422c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77f170481da6131ee117d300904fda1aa6b05bfd08d1294bac45ad96393f582f"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./cargo-crev")
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
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system "cargo", "crev", "config", "dir"

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-crev", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
