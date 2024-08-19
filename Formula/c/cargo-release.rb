class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.10.tar.gz"
  sha256 "3db220c865caa9820bf2d66c0c5a5ad5a3c7be7ec91c27c623c0f62c3754ea8b"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7c07e9e50acaa437102d150c19438010639926e59ff6c019aa2f7524f5235a8d"
    sha256 cellar: :any,                 arm64_ventura:  "ea281a383b6e283e47acda901f22dc9f7fd2d78bcec6b551678e35bd263596f9"
    sha256 cellar: :any,                 arm64_monterey: "4a952080706c1ab23784bac97e4365a190e35c6beaa033d44c06d64d6dabbdd4"
    sha256 cellar: :any,                 sonoma:         "13761de7169bb047880108b98bfb9521af814e32fbf84269dee694f994ad32aa"
    sha256 cellar: :any,                 ventura:        "6d9ab36ca7496a7cfae490b0c9e8d39dd6cf5c3ee3c2487f989dc1f9c92ee9be"
    sha256 cellar: :any,                 monterey:       "c8b71de7ff3f3c64074c92d8d8d28dde44a927434efd922bd2ce066e447261ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e52e3ace6dbc23d858818dbefd0c351ffa13b6c4bb78a66b5f1ef8fe74abb061"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2@1.7"

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
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
