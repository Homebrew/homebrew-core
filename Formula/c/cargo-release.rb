class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.18.tar.gz"
  sha256 "a212d974db4cf46e580cf41e1f0bcf81ff30aac1dfe9e31cd0dc89c0b5eb3586"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b9ef97a22b96c2855ff78669f71a2262e3d021e490f63a0846ef1822f5ab1e8"
    sha256 cellar: :any,                 arm64_sonoma:  "3938cbec73223f3399ba771d6a2d64067a3c8783120e69bcfd51ac0f148b66c2"
    sha256 cellar: :any,                 arm64_ventura: "6978e3f6f0830214570a66544466c79ebf9d5aa06ca9dc482713422aa7a7e43e"
    sha256 cellar: :any,                 sonoma:        "112c6f6dd8f26537171a283851da6f236cb0cb5f9001a09deb188f40e79364f4"
    sha256 cellar: :any,                 ventura:       "3808557d4a75b9a295c60f887c0c67163c130bf1065b21b946842bbbc29cfa80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d02b46b6b026b5b87c6434da3c840ce18d3227d256607c9df0dd67ec8877d732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39931a7937cfbad8a1460122044fd01d78e2472af66d95d2a09f2b7970c673f8"
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
