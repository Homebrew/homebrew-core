class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "166333f7d1d903c00720650761b1f82b1b44a63e7565931aa6669de6321a8f1b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3669b75e58c4a25e350134a020ff00fe321a843f0d8d7d09ff1c10cbd190a356"
    sha256 cellar: :any, arm64_sequoia: "6294fe0a61a85c6e3f6d71187729083781574759d80dcbfe6147df59174785a4"
    sha256 cellar: :any, arm64_sonoma:  "4fd1c637945ca2ea77731c41168f43acb61a63b34979393f33a2f5aaf3f8765d"
    sha256 cellar: :any, sonoma:        "9459b9f433f084a42bf7f1931b1e8448d52f95a1ef21f6fc725bdfa01b12b476"
    sha256 cellar: :any, arm64_linux:   "9ca898952a6a43739b2ca4a7163580b67ec8cb1965dad9e47b5e6e53adec8fc6"
    sha256 cellar: :any, x86_64_linux:  "9b53c1d47b735c7eceebef59a5fae2cfdea33f46f97bba375392b3ded02d9746"
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
      formula_opt_lib("libgit2")/shared_library("libgit2"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
