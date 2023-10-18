class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "f6b8d66998952f3d510b15ba08908d1a84588368e0ccb9fc7066d81c0f64a9d5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "21e37fa946d5d0c60d265e063436b46b8dbad3edc1c17906e3cd55a80303c6a6"
    sha256 cellar: :any,                 arm64_ventura:  "c52e6fa3cbc16037667619deefc0246f2c2a2cf9183e1ff209114bb603297c77"
    sha256 cellar: :any,                 arm64_monterey: "ab312ca689981c13146903589456f6858ddd6f5608978d2ed9eff7b161c62dc5"
    sha256 cellar: :any,                 sonoma:         "92dc96a2db870e7b8f96b5302dab3fc1b4c93f0b3d15b12f29d4bc303d578341"
    sha256 cellar: :any,                 ventura:        "80948a5518978e9a29bca60e8f841bf9f8d05ead107451668df9accc565933d6"
    sha256 cellar: :any,                 monterey:       "e5a135860ad259ffd1cfdeb8d84fd558a677ff1526ed496be39155243b90f5c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dc65c9e5b83f4ea36d1c76c436bece93bc64e3b3c965895904c7ea9ac5b1f7d"
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
