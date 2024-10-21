class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.12.tar.gz"
  sha256 "e79c518175db6f71ac8bd30d5f7044e8333d82103cc7dc4e82ffa8bb4d39ed39"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4cbf33589cbbd11a590e5efe22fa0f10b48a3263adaa84aa443fd70d2f995baa"
    sha256 cellar: :any,                 arm64_sonoma:  "f8c2491ca341052f41e28e4e420abecd90c9a5afb1d29323e50d7b146577a0de"
    sha256 cellar: :any,                 arm64_ventura: "8bd3e1f9292fdfad9b409c61563473ece47e520bbcaa84a80c5ad276f8da9431"
    sha256 cellar: :any,                 sonoma:        "c7f4eb8dd8d21adb822b25ad777a7247f7cbdd1b41d394e5d0ab5d2a32dbbb36"
    sha256 cellar: :any,                 ventura:       "f416e2deed4dcfef063526a5d2382e5f1cef673fbaeff2614f615ebc3b52a953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1a46d92a0f6e177d3149a888c3f5ff47c2b2f4d3923c9d3a631caf57bee31f9"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"

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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
