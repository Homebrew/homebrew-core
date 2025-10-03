class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.19.tar.gz"
  sha256 "6026c2e1c03a169e2851b22c788435eb96cbcbd93534d1cecad6267dd239399c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f161b15d3ec331bc3c968a0b47511cca8252090255b76573c03fb0245d8c661"
    sha256 cellar: :any,                 arm64_sequoia: "ce92902b6a806ca89ee2c19520892c2e8a2a8214689059183915d12b17ea34fb"
    sha256 cellar: :any,                 arm64_sonoma:  "c39ea787b12812f83fcc178da95c9453715efbbdabe05aeea57802d46a1078ee"
    sha256 cellar: :any,                 sonoma:        "45bb96fff741bad399036b722fa300104ed67a5fed23192963e71fcdb44977ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7985ef83cc57c02c525a0a8a2086caeaa0ede98fdde5bc16dbca0c303fb5ccc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "799b9c81b8402b51c0d096c0328efaa861889de5ea43971f23452fac821b2e76"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
