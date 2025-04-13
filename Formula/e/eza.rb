class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "885ae7a12c7ed68dd3a7cca76d4e8beaa100c9e9d6b7ad136b5bb6785e16b28b"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15f4cc6f995bbdaaed27baccc28373fd790e68083b4555d3418a4d0ff6aedb51"
    sha256 cellar: :any,                 arm64_sonoma:  "98a6117bb2be4c3763ebe1cb7f3915bdd3c4e7c200deabf90b35ab14b136fd79"
    sha256 cellar: :any,                 arm64_ventura: "4028e5ff1e42d3c3225cc527b72e2720810e81e17be6ead39f5c51ba4ef19544"
    sha256 cellar: :any,                 sonoma:        "1fb312def6c6ba32597d2a162cb7b28138a17d6afb0d5335d7e13de3b89bb7ae"
    sha256 cellar: :any,                 ventura:       "2ca570736c0aab0e989a0658d8d3c308cb9865010a7cbf30523d62352eab2014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cafda4077ff16f62186e10cf40daa8c5cd231b810e2b321cd494d178e7f68165"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/eza"
    fish_completion.install "completions/fish/eza.fish"
    zsh_completion.install  "completions/zsh/_eza"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "man/eza.1.md", "-o", "eza.1"
    system "pandoc", *args, "man/eza_colors.5.md", "-o", "eza_colors.5"
    system "pandoc", *args, "man/eza_colors-explanation.5.md", "-o", "eza_colors-explanation.5"

    man1.install buildpath.glob("*.1")
    man5.install buildpath.glob("*.5")
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin/"eza")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}/eza #{flags}").lines.grep(/#{testfile}/).first.split.first }
    system "git", "init"
    assert_equal "-N", eza_output.call
    system "git", "add", testfile
    assert_equal "N-", eza_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", eza_output.call

    linkage_with_libgit2 = (bin/"eza").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
