class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "a1a8b08055c4a69d0c1df03ce33eebf7226c5f419092ca091cb45f2ce58582d5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6160a1beec82252470294813ef7132b93b5903faac61c5e42c0a4b3fa581364c"
    sha256 cellar: :any,                 arm64_ventura:  "61e1cfb92816f4046af3d78613200f6bf3ab6dc50cccdb7ad6cda515a8f57a95"
    sha256 cellar: :any,                 arm64_monterey: "0808bc785c80e109eb5062cd8d86152bd10158c16d88f473d491b9f342fe9ed9"
    sha256 cellar: :any,                 sonoma:         "6031988a1643e25d42a61da3c24e1bab6e1a81a5e8f28a594f2bf7cf25683c0e"
    sha256 cellar: :any,                 ventura:        "7e7aaff4ba704e59fb595e7812ad610dd84e14a3ac593aa74e15f1144aac5854"
    sha256 cellar: :any,                 monterey:       "26e5938119afa521aa787be70a64e02a7a3e092d00537214e09e8a5481fc0e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61bad35bdbd65d01d675062de2cf371e328a05a9daf8063baefbaf2ea7304267"
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
