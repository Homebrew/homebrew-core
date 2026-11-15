class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "7ab7319bc32972954e1c71314ce32f4b475d4819df26aac9a829b36aebf54f84"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "af056fcde5d30e8ccc9102e83d828197adcc6ac289af857f1e12494d1148e6a3"
    sha256 cellar: :any, arm64_tahoe:       "bffa531c2bba6bc31234cef9f58c8cfa42503828f4d076fea3cf2d38908ebef6"
    sha256 cellar: :any, arm64_sequoia:     "1082d9b1e57b001cffecc70bcdbb8635450b735920b83337e60a20d0127a69ec"
    sha256 cellar: :any, arm64_linux:       "a525563f4d5c180bbb50be7b1d5075060fb91459c026c49a388cfb674587c4b9"
    sha256 cellar: :any, x86_64_linux:      "3363223d8728f33cb394c3c726620593dee5f1c491b751790f49b862c8470b58"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
