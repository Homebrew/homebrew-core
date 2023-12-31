class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "acb4b54cb60097459ec74f4b7f74d2623f45cc4172b16ef0fdd9a7fc4b4625a2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7eb5f1c1491b3125e3eb3a3e7e87ddefa0b67b4a6fb8555736512e2a822b975d"
    sha256 cellar: :any,                 arm64_ventura:  "88ee3599561d71740b74d2abfe8136b9305b47df49ee9f6e042c3738bf63fd8d"
    sha256 cellar: :any,                 arm64_monterey: "7c50d0b9b804273b2fbc1b40b1f49b8765b8c010508cd29834a179bea49f2152"
    sha256 cellar: :any,                 sonoma:         "006a6677b113164ca2b3a9fd35270525bc62271129110ee32942827c0f2e2376"
    sha256 cellar: :any,                 ventura:        "d931db16d036f65525efa3f7e3a7fa317beb4dcd8eabfece4cc5bff4d43b228b"
    sha256 cellar: :any,                 monterey:       "3020f72b031cc7f7364be026b04ba5a052205254038dd0ea385322a61b2a6e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eba2b046095f377ebf655178865235c3574a91949095d211fcab7ccdc65f09c2"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
