class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "ebd13c47763cb0cd9337a1d6e89e1a3be4e76e0dd9225ac8058d6d338c617a29"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc5d033fae5f316dba27b565b9b0c0d15c1cbc04b64dd0943067a77563621bd7"
    sha256 cellar: :any,                 arm64_sequoia: "7fa419ad21d8703e5c8a1433075795d35c61ed76f8cefcc88bfd09767b64e25a"
    sha256 cellar: :any,                 arm64_sonoma:  "f79bbf492ab8b4d1300e688e7cdf339305db15330c4e05790780613f00f0a29e"
    sha256 cellar: :any,                 sonoma:        "7623dd3834a4e72d1b90f304877f6ca76d1b043d68847b62b6e8d9c7686d0af9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a598170887ca40d3a9a9d848275dc9cc91bbde3ff5f32e7d974e1ab5dbe3a420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d25f283fa9be39de9e6641a8c4adb6ba278bcf4012e5f6caad5176d62ae982a0"
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
    # `eza` is broken when not passed a file or directory name.
    # https://github.com/eza-community/eza/issues/1568
    assert_match testfile, shell_output("#{bin}/eza #{testpath}")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}/eza #{flags} #{testpath}").lines.grep(/#{testfile}/).first.split.first }
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
