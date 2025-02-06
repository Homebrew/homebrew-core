class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.20.19.tar.gz"
  sha256 "b749e7b04c173f33cf15f0022d103bb59e79e7d2a88ec00721f2be0316cc9ef9"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7587134f181fc5295e1e7ccf2965057fcdafe428d1808ac8ef9dea6e7c081565"
    sha256 cellar: :any,                 arm64_sonoma:  "cb078bb72c0360b0094ece29ded3c58b703f5d8aa2fbde2c5beccac557cecb2d"
    sha256 cellar: :any,                 arm64_ventura: "33d421a586bd836624ee224ec13e3e69fcdb7c24e7d9f27f3504d6072018c011"
    sha256 cellar: :any,                 sonoma:        "b9a4efa0d673f30488c5e2a4e948fb4d070d1d872611183f16238fc849c0a2ce"
    sha256 cellar: :any,                 ventura:       "782eb06142d19429965d66ac7721f498a3bdcf88fa0150cc2fad35e9a5af50a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1a04b030b4634accd271ce05b0be75dfc005cf86fb78a074c0b954d9295130a"
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
