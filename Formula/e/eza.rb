class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "f0827d39406f0799e6676ab87e349193e88b6220af1670e98b988e8ee0c2b7c0"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b668939f24c6c71db1e6e972cfa5d3fa7daeebc39431d0df61c98e0cfb52a42e"
    sha256 cellar: :any,                 arm64_sonoma:  "c348c72d961823c0db50f6b567eefc01c0cc0b840928fe417e7c1293dcaf89cf"
    sha256 cellar: :any,                 arm64_ventura: "c24539c7b7e837cac1b416541e9ea23514c5b2a5b2508d689929812495b31413"
    sha256 cellar: :any,                 sonoma:        "553581af7770a1333993dab72e53af33d3631b32600571197faf888dd8e8deec"
    sha256 cellar: :any,                 ventura:       "ed55c47c8747f6db6431907ede1e94fc8f18fc2e53d958333de8fab9aa527035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "832e55526085c9b38ae5e9a13beb1a6b57ff515aab48393939ca90d6f10c78b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8997ec5ce88477660636889bf8e09cace2155d562644bbe0ec8c4297fc5fdd4f"
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
