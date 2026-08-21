class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "6d02028b9b1525ad6890a792854ad6e74c2a7cd791f118c442293538ae6bbf8d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e8143b3b07f8a3db22aa5c9f41626a9407683c2279307f3b54452588633453c2"
    sha256 cellar: :any, arm64_sequoia: "c67179f0c3287daa8b30816c17db24a97d86cc54ad375b6d8698d3fe1caa7987"
    sha256 cellar: :any, arm64_sonoma:  "f907623a89a752758a85aa0d618e4fc8a22c9ba4530ada1edda4a4fcd534fb63"
    sha256 cellar: :any, sonoma:        "8cd9a7eac06dc602d82238a0a30f34fa3facb880a043afacda76270b2b66b285"
    sha256 cellar: :any, arm64_linux:   "6fd38b5892f5375026aa7709e229ddf89fffb6d6bceb179e2c757f64be3d3fbf"
    sha256 cellar: :any, x86_64_linux:  "d7e30f0990b38b86522c2d0462a8f5fe5022472cbd168d23b56c1eb8d73c4765"
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
