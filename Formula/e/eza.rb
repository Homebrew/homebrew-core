class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "4f11158229a163b62d2ae1f632b87c36d213f78c2bfd5a85775b4aa3d21a4c0c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bed6fc37b93a45afa42ad0fd31d0c5ead8fed92bb78faf76d9db9c3b6472fd2b"
    sha256 cellar: :any,                 arm64_ventura:  "9ab1e27f5294ecfcc1d555a9df2d96c9b56863db3160a3cce3dd3f41d75c73eb"
    sha256 cellar: :any,                 arm64_monterey: "c0fbea795705466fe1665ad0ace2f76bb6c2cca219924099c3d8411c72654d11"
    sha256 cellar: :any,                 sonoma:         "6e1045ede01b65204b31e2aca24fbcf7f43fd0f4f7ef5db52f19328a23a1cb08"
    sha256 cellar: :any,                 ventura:        "943a62f5c1a95a2b643e33abe997e49045cdd48b75b858bf3451e437d377cb2d"
    sha256 cellar: :any,                 monterey:       "0bace06eb4c5b23152370e2fc23c839dfb33c1042dac632a4d6be8650f8ef7f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08261844c441e9f0d3b15923c56320cd09d02d07849a1ab8055b2d60b86f3ae4"
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
