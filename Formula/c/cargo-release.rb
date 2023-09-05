class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.11.tar.gz"
  sha256 "cbbc04f7faadd2202b36401f3ffafc8836fb176062d428d2af195c02a2f9bd58"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f8b1bfec6f16ce16838cf6b8210ca1d8c182dc4cb9c633fd7de6f59105b3f394"
    sha256 cellar: :any,                 arm64_monterey: "16c0a2949f3dff1e205c8b1ee1bbe1070249b696cd3c5384b6530c25738c1c9b"
    sha256 cellar: :any,                 arm64_big_sur:  "b9829ecd476c861567a8e346833fd722ffc67f119c638f83932b09b18772cd5b"
    sha256 cellar: :any,                 ventura:        "5870c3bdd06cf9bbe48e8e150741d264d83eb960cd32e7bd9c6f6ffb3631e583"
    sha256 cellar: :any,                 monterey:       "10e28093ccf6f0fb5ec7f666b2f1fb5de6b1d313f7ceb92fcd936e35ba9d860b"
    sha256 cellar: :any,                 big_sur:        "a5c69286603566b5cabd08dae10cd218f836724621e4fc107f4442fcbc3ae19f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4faf11eaaa11c84ee73c8727e0224ec680fd2e1e219c5ac2b0c02f8d934b4994"
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
