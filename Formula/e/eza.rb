class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.20.17.tar.gz"
  sha256 "62bcf8f1b2d087fa0c2c8365e4427ad30ffa986330413191da47061aecfe20de"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "23cbed3221bac785fe5c1ebfd54157a663a9b4bfcdd37e6dd4e7529f77624851"
    sha256 cellar: :any,                 arm64_sonoma:  "450f609b460c03e46cd33c77af0e63cd948169b38cf502c6ef7f796a21926364"
    sha256 cellar: :any,                 arm64_ventura: "1328de2b62c1f425ad37c1e391ed88895f6318e00b9567b8e1f657c16669b11e"
    sha256 cellar: :any,                 sonoma:        "75d888932421b25867c44d098816c90009ae148fb746f10367b8618e36f07fbf"
    sha256 cellar: :any,                 ventura:       "9f9ac8ad287a477e73ce315dfdbc7cda0f52292bc5a975b9f8548f692e01e056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203a952760d910f5ae53d0b672b035b0c47f8341ebc306dcf08d199e8e007809"
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
