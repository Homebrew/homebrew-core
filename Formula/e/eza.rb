class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.8.tar.gz"
  sha256 "4169f57c522cd17e195a7bc36a9ea671e5b1d905f9ab57c66a49f6edf343179c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eff6163b6db247202f39487308cf3ad0d16cc9e5fa7f81b254e5e0dcdf1e7d52"
    sha256 cellar: :any,                 arm64_ventura:  "cf89e17b357bdc89456a383fe5805efde0e7008e0bcf8209c74263053722af1a"
    sha256 cellar: :any,                 arm64_monterey: "cf3ab4fdf0a0dd1b680405b5e0da55e57762f73dd5c2e67961c4878210547ef7"
    sha256 cellar: :any,                 sonoma:         "06419681a28ed3a0926aa15bebd67291cd7fed62b67f49d497cb7668f0546c43"
    sha256 cellar: :any,                 ventura:        "2d86f0864726e2a108444d88bbfd4ec3bbe852b98c57d7e1b12ce9ed83b4197f"
    sha256 cellar: :any,                 monterey:       "1be0dc9c8ccad195c20a659ca7d076b98d45cad8a08ea2c571b98f58d05aebba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a8f4fadb324e77b71caa256f344c9d442623d5c9dda1bce07a2522cedd2d65"
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
