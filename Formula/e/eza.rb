class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.10.tar.gz"
  sha256 "b0b59a7bdd7536941fac210ca25d30f904657f906aa2c01411fb390d4bdcd139"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6f684bb63051898b3e25d0b7dc19234243569d71cd89b3b85dadd83a1740f1da"
    sha256 cellar: :any,                 arm64_ventura:  "239161f1aeecbe116497c18fe94b703493851c5cfc14835124c49700173a4e69"
    sha256 cellar: :any,                 arm64_monterey: "cf3616c83c92d7f8abf89ac4674197fb1e3880104be4df1bf3e795cbccfbd9d6"
    sha256 cellar: :any,                 sonoma:         "ab2f070a093c7d5922d87921f193e499266d189a129c8ef43045c7ba8029b20d"
    sha256 cellar: :any,                 ventura:        "ef6270402e1becd9458cd685c5114fb1193cc6c0f6bac44330ccccc58ca26278"
    sha256 cellar: :any,                 monterey:       "6f625e60889c55a47601641fb797654b7c386de9aae9cf0dfe3e422c9a62870e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c8db39962516031f726931376cf27ebfba7042b6ea7a7ad797961b524bac01d"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
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
