class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "440fff093c23635d7c1a9955d42489a2f5c5839a0e85a03e39daeca39e9dbf84"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "33ea0327ed69ed9041f6f8137fba5abda723579105951673ea1aa1764af8ad99"
    sha256 cellar: :any,                 arm64_ventura:  "7a59d2fddbd57fe0aab40ae2397758b859345ea6b1cacfd2fc602013809c9f31"
    sha256 cellar: :any,                 arm64_monterey: "73f7e0334d97fdd1aeac7cdebbe1b0f18f14cdebff36df0f15f5d37b9227bba6"
    sha256 cellar: :any,                 sonoma:         "7087f92ce8579ef43ea3be4398277ff5a40c9c71e10622ab8486fd416bbac1c7"
    sha256 cellar: :any,                 ventura:        "0859deeee2dd8d3728bfe28ce143ab8b2f10d7d2a6a6b0fadfe244347e65875c"
    sha256 cellar: :any,                 monterey:       "397ae990fddf597ed12817735a026b7244fee7b3280bdd13952fa81f5933c496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "289d853bdf0fc321841799422f67464b589fe220149bdd35a78b1706ecb996d9"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
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
