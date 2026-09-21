class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "7244e50f80b829383ead0bf6a026d6e1773f661fd7e3db4369cbad2d42f83ae0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d0e8ef22e8e6681fcfc72c7a58dfc03c791cbbffd7fa0179b960bfa6f1e12e76"
    sha256 cellar: :any, arm64_tahoe:       "5a20de5114d2575862b5af7a94b25790218cc1e2185a2f34ba44f699565078d8"
    sha256 cellar: :any, arm64_sequoia:     "9935f38040ee08d6d56a590ff8fb2e13b04dd876c16450ff88d774c3ab2a2a32"
    sha256 cellar: :any, arm64_linux:       "60131bb26f71cbb46e3d7c708ef4a57b7f8261f5c1bec9b4164d6e78044003d7"
    sha256 cellar: :any, x86_64_linux:      "c2cf6b018906b7b4fd5506221c212e2f8e852d4c86faee7d193b36972f5afde8"
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
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
