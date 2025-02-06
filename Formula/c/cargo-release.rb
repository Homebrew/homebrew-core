class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.17.tar.gz"
  sha256 "38dc83a5307492fb3d0d03c6c8eb3f8fd38e4a89969e86085d429c75071007dd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "841df715164446844ecc32ff62d2d2709ad89513035e6251816e8de4dd25822c"
    sha256 cellar: :any,                 arm64_sonoma:  "fa050ffa1be06138e43f971240ee4ca40892bdc24fefe9ee2ec0a88fe6ecc5d2"
    sha256 cellar: :any,                 arm64_ventura: "ad6b291135f0d31f327f60266a165cc3dde080ee71dd990fa71e1ea7c8f23a1e"
    sha256 cellar: :any,                 sonoma:        "3bf37526c8a3456465d0ce810bb8224ba50adc869bdacf3a3d92a8f65d4d7832"
    sha256 cellar: :any,                 ventura:       "2b1f9a3cb7f0e3b44678ac6cb3f121baa2a35441a969ccc6043ad9ab8f2a030c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ed8eaaf7a3d85f41178c69294b654b095eec9071c966b99c75099058707796"
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

  test do
    require "utils/linkage"

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
      assert Utils.binary_linked_to_library?(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
