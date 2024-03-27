class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.9.tar.gz"
  sha256 "917736591429813ef4cfce47bb2d3d87e9f1e142b2a6ebf74a345c3a15894918"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89375ee00962c58bb3893428120a163c71a4d5fcaf5d655a8c41aba463636a1b"
    sha256 cellar: :any,                 arm64_ventura:  "8f9991869671188c349731b9587896d35bb3b5cf18bac4c3c528cbda34a313ae"
    sha256 cellar: :any,                 arm64_monterey: "852d84659477a80a4fbcb34818eb1d02d26881db5e9fcdfe25282d18b4fd5d1b"
    sha256 cellar: :any,                 sonoma:         "9e53bca5d4efebeda9a426efe397b79a9157ebd1406c81eb7493f62db292550c"
    sha256 cellar: :any,                 ventura:        "c953cfb420870e7b2a01b8442bfa46620856e00ed731824017bc1c3298c1eccb"
    sha256 cellar: :any,                 monterey:       "20bd0f6414766895dd1a4b598cb2af95b7ef9e369ac1561648d17a3c5ea4cd2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02811528e23cadb57f6eda404c066d278ad2364e6e01028202a6e35175eb6dbe"
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
