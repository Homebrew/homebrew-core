class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.15.tar.gz"
  sha256 "53c6ea67804dbaa330918f6ce62a1cff866a145b2395c606903c0d128dd8564f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ddf97b2b0ae62bb4f3c751af94db357d0485742fde0ec905b57fc236d72151b0"
    sha256 cellar: :any,                 arm64_ventura:  "69d1b2de3d8dd12f8cf9480d8d6f640c934260f662d84935abe8d76186788dd1"
    sha256 cellar: :any,                 arm64_monterey: "240c09749ed6b77bf854922b4e154d6f48bb1d21334518c588e3f266a2814470"
    sha256 cellar: :any,                 sonoma:         "cc8bc2358d9704f90fb5d82c201429114312051eb22e58e09415c8cd9cedfc8b"
    sha256 cellar: :any,                 ventura:        "c9290bf0eb86fa747855d48715f7a0765de92537fedc1182a76ae1590a10295e"
    sha256 cellar: :any,                 monterey:       "adba3ac2031ce08b970e258b15967765c25aa48c314019e79dba9132883e30b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0659fa19a226517deb4712e1930b5203929b6ed38d8784cbae34cc55c0f0a211"
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
