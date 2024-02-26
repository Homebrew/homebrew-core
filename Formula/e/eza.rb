class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "2200bc1c07511c105961dcb3fe1682cc9067d55280dac990de7623aff86cab1a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "309e1ff17997e9f610ec17ccfa95917218db4097968d0eb7b893295bf2972750"
    sha256 cellar: :any,                 arm64_ventura:  "632817d9c5fa0be02bce3ed8887756cd181a302d8998b347efc790849480abd7"
    sha256 cellar: :any,                 arm64_monterey: "13db54fd6c5fb71535a2af57b5e2a9926a353ac3dfed17cc5847a6b00dfa6176"
    sha256 cellar: :any,                 sonoma:         "79fa3a1d0dbf00b410b47d7a2f6cd546f527dcbc30b7e13f65dbc7e128b7930a"
    sha256 cellar: :any,                 ventura:        "c05e2d145c8647a1b4fcdaef2677502887c4c84a7ef24201bfa536edf7acb8eb"
    sha256 cellar: :any,                 monterey:       "6fa39d3e4d10db590f95006a7b9a0314a5eb7d22695979649d7a460b09b0cc33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7c097ef76a6465b50048c578138863833a61cf553fc34b774ef6f472f21a92c"
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
