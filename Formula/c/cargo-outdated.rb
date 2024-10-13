class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  # We use crates.io url since the corresponding GitHub tag is missing. This is the latest
  # release as the official installation method of `cargo install --locked cargo-outdated`
  # pulls same source from crates.io. v0.15.0+ is needed to avoid an older unsupported libgit2.
  # We can switch back to GitHub releases when upstream decides to upload.
  # Issue ref: https://github.com/kbknapp/cargo-outdated/issues/388
  url "https://static.crates.io/crates/cargo-outdated/cargo-outdated-0.15.0.crate"
  sha256 "0641d14a828fe7dcf73e6df54d31ce19d4def4654d6fa8ec709961e561658a4d"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "86b57b5f303ed5b7244fa35577ab22e976c93d156c98cab15fce93fa8ac3bed3"
    sha256 cellar: :any,                 arm64_sonoma:   "bd1d9196b5442029200c34d51c23175f61c899ac4e9cc95ebbe7ff4f3641d177"
    sha256 cellar: :any,                 arm64_ventura:  "d75a6a4ab730f471c3cebea7e2993f09454e14d9faf2162175a02bdbb1424339"
    sha256 cellar: :any,                 arm64_monterey: "9cc2cc42be17e9f3c89c8389f4df8191e2d4eb60f9036ca79ab2e70c67bb1e51"
    sha256 cellar: :any,                 sonoma:         "1fbf19e465ae01e3de9156a71da3a9c31a958bc81793ca981688ccee6e03b1e8"
    sha256 cellar: :any,                 ventura:        "66736cba56267d3a8fa366e8caa54b4f327864561a984d74592a4f7cdff9997e"
    sha256 cellar: :any,                 monterey:       "393cc224deb953a44ec760626f335df0e5fac89aac7e1a74defb7c572c27bc91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bb39e0bca108a5dfb5b579d31d17986faa32ea3b7d8ae486a21199de3e591b0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2@1.7"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # rust 1.80 build patch, upstream pr ref, https://github.com/kbknapp/cargo-outdated/pull/397
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c17b2163d305f02e8b63639bfa50fc98a74cf72b/cargo-outdated/rust-1.80.patch"
    sha256 "6e014843621fa897952ea0ff35c44693156109db60e344190157a7805ace60c5"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
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
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      EOS

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end

    [
      Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
