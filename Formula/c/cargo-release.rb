class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "7121921bfd2bb03ef99e70296d672d2d6838b32c7407d50f9915c5d4ee28461a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c834f40c75a5bb29d2f0abd1ade85f9bf28bef15aadf7a3f38e95404f3f1fe9f"
    sha256 cellar: :any,                 arm64_sequoia: "d7d6c2b6e9e1d0ee610d5be134adbbdeb27f574abf803083d163d5267ca7e94d"
    sha256 cellar: :any,                 arm64_sonoma:  "8da7ca9e8d700f761590f6a5b53d50219f871801d2fadc4903a0f349b422a748"
    sha256 cellar: :any,                 sonoma:        "9155960fc4db70389d95227247e5a67bbf9937b3209b78350895a36208b19fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17a1f513fe5f9c04cc2941ed39e17646458f0a12ba9671f9aa59cd8f04de3710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94364844f0438fc1e0fd8a031780a0f662a79bf4fd1b1ccb52dcfa7fb9c8bd43"
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
