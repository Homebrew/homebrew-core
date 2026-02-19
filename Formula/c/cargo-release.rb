class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "59ca4bffc4a02c2fd2be1b5088706732330dfa7ec862072bdb17628c80c02327"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66d67373d5bec8bfdd7d5e34df9eb01531529e16df2b1104491cdc2b4d534cd6"
    sha256 cellar: :any,                 arm64_sequoia: "81dc91ab7b02cd5d1a8aaca7ed782eddfacd5b94564211ec4a9befaf09cd4a8a"
    sha256 cellar: :any,                 arm64_sonoma:  "1c01db976b179c5bdd55c623e804053a59e1ecb488fad816ad1975c20cdc2f23"
    sha256 cellar: :any,                 sonoma:        "380b356d1e90e4d486c24a8feb95134c53722526f574bf9435a89c8d76acd471"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a31973474c2b5ed40badd8b421145bc2f3f8c89d83fae304512d50854e3f313f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8433d5d1e4bde72b3ac3dea40a742aaeb7dc703aaf09ff89d316edaa3815d5f8"
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
