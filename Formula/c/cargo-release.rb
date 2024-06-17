class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "428886515fec3253e79bc079576e747687a7f3685c2a389c851b3583396db373"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d8afe587d6cc88af2227726fb911e155e860dbd2b85bceb6ccabc3cd6e60f21a"
    sha256 cellar: :any,                 arm64_ventura:  "3c0fe13a2b98f017d414ec0f7d739ff643e33e9fa06f1ed9c9a9cce266e38c84"
    sha256 cellar: :any,                 arm64_monterey: "3a7f0b5edd86699c8dfd2e720878d02321f246c8b3998bb9dda3d7db72d69f0f"
    sha256 cellar: :any,                 sonoma:         "2a9e38218bbd5e88592a420d472674850f0844f5f12be927f6a33b61481e307a"
    sha256 cellar: :any,                 ventura:        "f4e2299a85e7f440c77e0fd140b980afa44a600154b419c04c4655f2e6df8c63"
    sha256 cellar: :any,                 monterey:       "ac2cd69e6b7e54cfecbdf530f3e7f8eecd5e16652486aad94642553cf794b8d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f1b306f9bbbc029cef7e6293deaf59dc51ed4238babc535e38de6b36642d7b"
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
