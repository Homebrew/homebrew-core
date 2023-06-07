class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "88c92b175163c8847da7dd201d32106c51ff85e2c992c2a3ff67e29ecbe57abb"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c81826c0ae44b90c13912d923b7ba65225a122e2f64e61ce783e5c9b97ea611f"
    sha256 cellar: :any,                 arm64_monterey: "03cf91b68130d5e678184548951306bcb03819ede37eb51613fe5c6d399c1c40"
    sha256 cellar: :any,                 arm64_big_sur:  "3f1b43a5a36beb1ee37905d7672a18d953df49b39c18baae0e7e1cb7f508ab02"
    sha256 cellar: :any,                 ventura:        "cc1b80655a9397acc3943a11d964ed556311bc5d3ab3229edbac5a77cdc92def"
    sha256 cellar: :any,                 monterey:       "cf5b059970ed2dcc54f1a46d611f8ac18c327ffc04d5fe8b5a0197e0c9df5815"
    sha256 cellar: :any,                 big_sur:        "93de8b9211199c47f4a8febc955f269f73adb9f23c79c373e3ec3af0183cafab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "713d97cff263e042c5edb366abbc8ad93f9e0ccc2e7da04391c1d9ef700f97e7"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

  def install
    # Link with a shared library instead of building a vendored version
    inreplace "Cargo.toml", ', features = [ "zlib-ng-compat" ]', ""
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/convco.bash" => "convco"
    zsh_completion.install  "target/completions/_convco" => "_convco"
    fish_completion.install "target/completions/convco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(/FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n/,
      shell_output("#{bin}/convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    linkage_with_libgit2 = (bin/"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
