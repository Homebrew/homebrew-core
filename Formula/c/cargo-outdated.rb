class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/kbknapp/cargo-outdated/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "571910b0c44f0bcf0b6e5c24184247e4603f474c7bde5f0eaa1203ce802b4a4a"
  license "MIT"
  revision 2
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aa2214131cf25fd2d538428aa6619335604545a082b0437c2860f8e9b87e59cf"
    sha256 cellar: :any,                 arm64_monterey: "d5dd9bf61bcd2564a2902d52325780c01de19ee03e458d403aca3f223e9ad857"
    sha256 cellar: :any,                 arm64_big_sur:  "3b00d458873a9e22f1992ba05e5e670fd4517b4463eafe42ff6c412ac67c2b14"
    sha256 cellar: :any,                 ventura:        "0f3c8226b69b412c10d7176527c9dd40ff4d0781fef709283c3171db3a1563b9"
    sha256 cellar: :any,                 monterey:       "9a72734928b3551faeae251b6955b4dc060dac4e3bed37af7554db570aab5b36"
    sha256 cellar: :any,                 big_sur:        "b53fbcad34125c6f15de105c15c76eef98c1751a6ddf3d66ac983ff921ec81f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2a7c074738a25b95854fd998ac0231b76862c38d889b975eef94b42347e0c66"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/kbknapp/cargo-outdated/blob/v#{version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Migrate to the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
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
      Formula["libgit2@1.6"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
