class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "8a8b737aff1361677e3733133944728871ccf7ac00ea15b32f9d0ef6d5814f62"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3599b6c69101d5ba72bb1fc0c4100be176ee47ae7306499e35fe20f1b7be170"
    sha256 cellar: :any,                 arm64_ventura:  "7778c92bfce4c83a367e760fa2a141f60a92028c28759a2acb30735d644759ee"
    sha256 cellar: :any,                 arm64_monterey: "7f045f704f0c816fbe5ecfc9b11791b982a79c6ea4e9748b822c8046c322d1de"
    sha256 cellar: :any,                 sonoma:         "2aeaec5546018793975c9b879b4a5669f67dcbe608759740a05de23159c4b71f"
    sha256 cellar: :any,                 ventura:        "4c56b0b4131dfcd8b6990af0afd4b2abfec1feef0eb650c5b88a1f0bc847ff8b"
    sha256 cellar: :any,                 monterey:       "dd4eb3df299fde2a0ecd66e75c05d25768a43feb7656a729f019f4674ad7530b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94cb24cfc95696b2ffa4f9012f24e2dd7fa36d086283d96b62b1f1af1af61458"
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
