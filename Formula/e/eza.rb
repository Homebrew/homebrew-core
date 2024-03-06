class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "4cbca009d8ddc817d9ffda34bd1cada4278896e63051c645f0821605a6497faa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "928db44c17c3e34c8c8298b1f5b72160d5b5904d62b7b8d716321276d7a3d1e8"
    sha256 cellar: :any,                 arm64_ventura:  "e49d2d1afab410c638dfcb1ba4b07910af81ac3fbf649c494a96708f0812c2af"
    sha256 cellar: :any,                 arm64_monterey: "2096d6e1f1abb57d99294edc200cd2d576784c09d5ca3576c9c9e74ce51fde13"
    sha256 cellar: :any,                 sonoma:         "e2d386cf7feb0ceadca9be52eae86652a92410e45a7501570bf6dee003567d7b"
    sha256 cellar: :any,                 ventura:        "b1d5df38eb16c5c9bc1759c3215089e0686faf44c1bca33a526179678b41a755"
    sha256 cellar: :any,                 monterey:       "2616f37f3a0ecc6c6c566bd02f9e337811eed30c2c39db728157a0c243e76a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6b8f07abb0e5a82d36f9b8ddb6ccadc84ebffa73f4d83631be3bd9817148a30"
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
