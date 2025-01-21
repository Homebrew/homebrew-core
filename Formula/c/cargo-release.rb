class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.15.tar.gz"
  sha256 "dee97fbcb6124f7d159cfc0ea8fb3977da1513da2135b179bd48dbcd0abde616"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2574c100ae1015f8400a41596e75d55a42b9685b1409711f20ee9a6699b933f7"
    sha256 cellar: :any,                 arm64_sonoma:  "0f6d3557c3ad479fb4360c77db610c57ed9c878b2e7bba9569c5d0d47d4965df"
    sha256 cellar: :any,                 arm64_ventura: "17dc706dc7989bb6ff4f71fa805fa919e3a2d49a568a631445eed34c3233439d"
    sha256 cellar: :any,                 sonoma:        "755d6c97605883787a5c3e41f1d95af5dd06c811355af98ae6c6f1ff650d1e80"
    sha256 cellar: :any,                 ventura:       "f6fc62d039fac5fdce20dea2b9f1061f96f316dbe117fb0577041b829dc3212a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e63024709978df9416b5c9f399d37aea926e3005fdb35c8cf8d47dbb4693eb4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2@1.8" # needs https://github.com/rust-lang/git2-rs/issues/1109 to support libgit2 1.9

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
      Formula["libgit2@1.8"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
