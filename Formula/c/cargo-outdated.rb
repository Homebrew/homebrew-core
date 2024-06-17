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
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a64cfa869ebf18a5b503eb18e9fff3a5bfbe03ff140c13632ab474a9f4aec52"
    sha256 cellar: :any,                 arm64_ventura:  "97f5a8cd382904cbadf6cebb05aa4724f1a4ea2e33c1de7dc49e1d5e3779b645"
    sha256 cellar: :any,                 arm64_monterey: "66c5b1160d69b285925f22908da23f5c16e012d02c2886b47dbb2e4e296fbaa2"
    sha256 cellar: :any,                 sonoma:         "6b79a061b01990586e093d97fac5dc62a14d2d15c6eb70b45935d6ccfacf3de6"
    sha256 cellar: :any,                 ventura:        "6bd512544a6d9822d3a049df30d68300f462af2df0d1476822623d3857f2280b"
    sha256 cellar: :any,                 monterey:       "5a05df06ef26ab97b72391a7bd91bf06afe8b016944c691557d0063b76971492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7543eddf05cf16cdf8c4f938e19509b9a1d160fae615f0e7aa8603397e8d5740"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"
  depends_on "openssl@3"

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
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
