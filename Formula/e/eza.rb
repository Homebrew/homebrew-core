class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.17.tar.gz"
  sha256 "fb9eea00bff8ad0283c046398259f03b1ce2830a49cdd7417b65c9dade07d709"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "507426d2ebb07e983d940e1a4c0fa7a8f4c3f0fd2c4caeec37bdc129baaf18ce"
    sha256 cellar: :any,                 arm64_ventura:  "7323d0d58ae85f1bc388a02b3d317514b29238f6381bab649258acbc55a0539c"
    sha256 cellar: :any,                 arm64_monterey: "0f4f449d85538af0366d6c1db4b762b08d2ec7e36487cd6dd3af1160ace88a60"
    sha256 cellar: :any,                 sonoma:         "bd79747baa6c691de76a152b32378d92cc5f051306f8dc6593c86ee7777e0d63"
    sha256 cellar: :any,                 ventura:        "9e217bf4307ecde22df4aac72d97c315d7702e44718e5b8bbb2f0c98d0721ed0"
    sha256 cellar: :any,                 monterey:       "f28d08223f22443211d5417ce0b89a7ba9555d1189cf8c12e0941baa8019c6ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82eb0a376d2344d70d6d360dbb9266849d85c48b9ff289025aa6eb6784447398"
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
