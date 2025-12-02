class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.22.tar.gz"
  sha256 "ba7b6d126d4042f709453106bdb5392bf6aa88f1be25c028bf47f5f1da8a2b97"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11e04e92d65adb9abcf892b35fd83c6d1364d2680f44e22e237f51bb60dd8222"
    sha256 cellar: :any,                 arm64_sequoia: "412f78929909c97ed6c1d7b7da3f478bd8302f1511da5a93d7049aebb2650c3b"
    sha256 cellar: :any,                 arm64_sonoma:  "6116b41b83dc38ffbdb85d6544781d71c87d37552d0949c1b89d0bb387f317d5"
    sha256 cellar: :any,                 sonoma:        "c10784d991e5aedb06b7e1869a2b47ebe2c14322edc6ebc7dcc866a40b63bc94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d40881fc836c6d7c3c4d5533bc6465b53646833d835edb3bedd5d3fdd9ffa1e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "724a3edeaa30bc7973e584dbcee23f40501191b850b96f959a730c2e2f38f0e4"
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
