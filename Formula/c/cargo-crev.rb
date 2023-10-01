class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "cf47787896d27b866a30c1c5432f3335a35489e1e96a7da212e8bafd3f9367dc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fc0a54343513092fc266aa556dd646c9040c92506ec073b6679eac9d59f3150c"
    sha256 cellar: :any,                 arm64_ventura:  "d9442463c0f068cc155707e5863655b2942741f47e0ad6425d49aa412e03f55a"
    sha256 cellar: :any,                 arm64_monterey: "6aa21f5406cb13217a82f76bcffc0556b4aa05da63377c2c04d9015958b70861"
    sha256 cellar: :any,                 arm64_big_sur:  "a71044e0be5b827ba94a4a575011997c1cb7db9166d95e3f7c199a9a104a00d0"
    sha256 cellar: :any,                 sonoma:         "b2403d97062233b88c870257274e9d8355efe384396550286e2731413144d6ae"
    sha256 cellar: :any,                 ventura:        "2f44cd13f105688622672e3b9eeba429117e5f73c53cb3c1f4b12fe863fe2c40"
    sha256 cellar: :any,                 monterey:       "b3e3d310257afac449d16e321d695872262691a03290e667b5ab29f823e881c5"
    sha256 cellar: :any,                 big_sur:        "325bc8db3ae10e41ed2a4d5887e4ec3022f6343eda4814009894abc7834b0391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94ccdffe2adf832cd8b1c8385415cbf726e1b3408dc951e143d08b3ebb135579"
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
