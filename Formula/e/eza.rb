class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "9fbcad518b8a2095206ac385329ca62d216bf9fdc652dde2d082fcb37c309635"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41991ad81cb8fd691125d28eda4bbfa0ebb14c6f902767402dc2ea8763ecf196"
    sha256 cellar: :any,                 arm64_sequoia: "2bc7df7c601dfb6b9004db58a8033a5633dfb731dbfc0288cb9cc0c4fc1a4df7"
    sha256 cellar: :any,                 arm64_sonoma:  "4371bc10070f7728a665b3e590903c1861b6882fb37fef7abfed93717e38dbc4"
    sha256 cellar: :any,                 sonoma:        "40120b86f48af531ff13393db0bbbf9fcb4c304bbdd6cb3bbab3bc70d0236c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8b0bd9691c73ab64a5542c0372d5f2f2e0e96bbc8fae25d5bb278ddde5e49b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bdf49feadb1e11bf7a5247cb64cf6a0efc6624ef7af0305f11e53bc0463bf77"
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
    # `eza` is broken when not passed a file or directory name.
    # https://github.com/eza-community/eza/issues/1568
    assert_match testfile, shell_output("#{bin}/eza #{testpath}")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}/eza #{flags} #{testpath}").lines.grep(/#{testfile}/).first.split.first }
    system "git", "init"
    assert_equal "-N", eza_output.call
    system "git", "add", testfile
    assert_equal "N-", eza_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", eza_output.call

    require "utils/linkage"
    library = Formula["libgit2"].opt_lib/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"eza", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
