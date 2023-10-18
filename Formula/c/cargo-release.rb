class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.12.tar.gz"
  sha256 "2b0e88b1ce96a95a97c4b136a6084d81916bb68de49bac70dd2d48e299bac654"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2861c7999fd556f54e4214ff9647f8f6a25588e2ac4250db7a99214f5cac5dff"
    sha256 cellar: :any,                 arm64_ventura:  "c1220849bf433dd4604abee375f2790118c1aa9d6cee63733c769c7ccfc87865"
    sha256 cellar: :any,                 arm64_monterey: "b56c7ae3f7de31880a517e081b8b6e7823ed3e03dfe4eb2c340413e608119bbd"
    sha256 cellar: :any,                 arm64_big_sur:  "426fda66942b2b406901b94959e1e6a22b4cf85f8c475a4299e41c16bf9979d5"
    sha256 cellar: :any,                 sonoma:         "aaffc2e74a9b05881a96183c0bf53cd9ce69bda55e38e178c778e11b4363d076"
    sha256 cellar: :any,                 ventura:        "8c8b4794590df563589aeafd48faaaf9af2455053ef5978e0a23fd1c5397ce11"
    sha256 cellar: :any,                 monterey:       "3fcc8af36b4e73d4f4760c128196ef926f7630b3a65db868f58c16b687749557"
    sha256 cellar: :any,                 big_sur:        "f2bd3595848df2a0b998127045f05153efd859d2e4e2458a0a0d8f70dbc50df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb0923161f4e8b978b7c4954af04900e2acf3752703206d29f9f54c5923b4a08"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/crate-ci/cargo-release/blob/v#{version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Migrate to the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"
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
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2@1.6"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
