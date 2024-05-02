class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.7.tar.gz"
  sha256 "f6991b128ddb248064f5fcbe29ea9ae714387d5ebf82645f36d0d9c87710a2e4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e26ea2e659007e2d9c18d8b1a70a1c7d6be2626ec75b354cf3f6b320dc228e0"
    sha256 cellar: :any,                 arm64_ventura:  "31386b7b858469be5fcb1a1651b2649e6e5b3fccadfd81d228c84e4b3fbbcb9c"
    sha256 cellar: :any,                 arm64_monterey: "896d0f56a2c0381caa2e753d904477e0f379c2ba3fb0d89d4894e5bdfb58fb86"
    sha256 cellar: :any,                 sonoma:         "1c2de6a1922d779700ef2ed9b891b236a624fa4649b5f1a861dc122ee91b33ea"
    sha256 cellar: :any,                 ventura:        "3f52817fbf094799700bdc0fc1f8c01c47c32a89026214616f4ae4ff6276eef4"
    sha256 cellar: :any,                 monterey:       "e4c721b8d8acff07b7f1369dace91e2ed927c80524fdb0bf14b039ca893fddb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e8a06574f628078010f8dc94f87e817ac9468797d20d65e78a6277fcc6b05d"
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
