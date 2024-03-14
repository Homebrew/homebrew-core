class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.7.tar.gz"
  sha256 "e712e3ae97ca7ee28e411b8537e20b1efb88b3e052c8053c13d70ae97bae9b61"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3e696c5df21716493244a48f0b71cf307da1af3456afe3bfe9784fc3c7e58204"
    sha256 cellar: :any,                 arm64_ventura:  "bdeca82d657a6196e9693b684ad10482e54f9cbf9b557b2e192506bef52da5d7"
    sha256 cellar: :any,                 arm64_monterey: "47d33f58e7d74c459620fb40c292a904796fb095e008a60f34dc3bf414d9cb08"
    sha256 cellar: :any,                 sonoma:         "24b77480f7729d3390f4ab3fce0011e1f3bfbbe12128a3afef2f4d473347084e"
    sha256 cellar: :any,                 ventura:        "f691040dc797aaf4decac7be6b59327204f1dc7a4f23784c1faea7e3d50b23a1"
    sha256 cellar: :any,                 monterey:       "79f7823d65dc605658b9eaa417445096f4e0cdade098c43f378aa8cf65b0c94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f95bea318cd27e652ff08e1e0090fe7964169c7679e218e2084f9733add10f33"
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
