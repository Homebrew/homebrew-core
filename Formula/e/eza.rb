class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "c5be22fbf8979d796509873327703353c243acbf42cb42b22b86be56cc11682c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "555623c618982b7e9cad3b6d60afa6fbba6b1f7134fff2e1ea8e16a4a8fcd059"
    sha256 cellar: :any,                 arm64_ventura:  "d325faf93de785c1df4650e8a90f13a6468c7ca232f72ffcd7132fd6230baa6c"
    sha256 cellar: :any,                 arm64_monterey: "7d1ad64e5812237474940dffb2678e41067e08dd4815cc4223dfcc94a7e75845"
    sha256 cellar: :any,                 sonoma:         "78f6c65a72079eab258c35b3efcf760dc8af5266091a41be66cc58b51a1a4393"
    sha256 cellar: :any,                 ventura:        "cf462f550837c07accf9a2f580769fb74899a0cd7f663d5f28114ec7c7d94552"
    sha256 cellar: :any,                 monterey:       "6d75b6a7a347a2e8386c30ee7b31494ce07e9c138ec0630f602cfe8a08df0df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "517f9099417fc8f11b7dd541d24a6dc3a7d3ac25b96c040fd0363952a2b08a87"
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
