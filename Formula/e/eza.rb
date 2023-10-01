class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "f175e21114cbea292fab35145428a54c58a69c22d871786eb6b0d7248f874ccf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "40f40db53fe4b1f0eb317616e0b18d94ce8b3579c8160682b7e0d60a4247e0b5"
    sha256 cellar: :any,                 arm64_monterey: "d6bfa6bb483181680e858ea1797a37861b2ca9db1f5f402ad90ef073e2680d80"
    sha256 cellar: :any,                 ventura:        "a3304d733a77501b006c379fc87ccfeede3d642913f9dbde88334644d2878fbc"
    sha256 cellar: :any,                 monterey:       "1b60f38239373ece20eb6904112b46f46c1641bf2ad6caa11dfc4589f24f4d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc7f8d706c17454d3b68b38682452c69b183a9d5d48d9c8132854fb66b6a2905"
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
