class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.5.tar.gz"
  sha256 "6db7bb8068fd6a2303668ab06ca94f2092aa0926957923c4ff37e900316ef084"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2792c3f1bcb5b4674c76397da00340d41bbdf15a32f40facdec5bba24c984610"
    sha256 cellar: :any,                 arm64_ventura:  "6a0a0b7e07884c5edada01e2a944c1750c7c7b79dc2398375d2f159dc1c32803"
    sha256 cellar: :any,                 arm64_monterey: "e705a02cc30c211f290e814b7f8918b8e512a876a67d68a074ba9d86e0ef3237"
    sha256 cellar: :any,                 sonoma:         "7b99cb0a1375950773dbea49143351505e3f8236526ae17093352c8f9ed6005e"
    sha256 cellar: :any,                 ventura:        "d72ceb9e1461ba8176b18b6a225725d1f85439d792f8967765c1fa9ce51ed366"
    sha256 cellar: :any,                 monterey:       "9b53837702bc76650f667ac41692a9cfbd2d47fcb396d0a9b984ac684b9082ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a8268e894031762778cff6ad9b6a7d9004e6a83fcba37cb32edf1a9a3305256"
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
