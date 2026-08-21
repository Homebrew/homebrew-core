class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://eza.rocks"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.23.5.tar.gz"
  sha256 "bbf179f2611c904014431740b559e8055276c12fcf978a7e31c271663548337f"
  license "EUPL-1.2"
  head "https://github.com/eza-community/eza.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "49b4351a61ebedbe102726fadb3638998cbfd98a81cb1a5f0e4fd0f1be30444e"
    sha256 cellar: :any, arm64_sequoia: "94b3b640649a5e89a6f75c15fa2fa66098cf78c4faf742a6d43771fe377f31a0"
    sha256 cellar: :any, arm64_sonoma:  "c40aba3602dda7fb2327bf8401f9c4b234e2f87a02c066fafb49f917f8cf1a6b"
    sha256 cellar: :any, sonoma:        "63b565307886da9465e9c8744e112c1872da74cf2a3e5723c38c49f49d5701d9"
    sha256 cellar: :any, arm64_linux:   "401228759a123919e80302eed23d749f59ced13a5ddd964343ef4c13029f9d2e"
    sha256 cellar: :any, x86_64_linux:  "246d2197c53ed155fa308c1da349f0c948f3a803642d0e40542abe769ba81894"
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

    require "utils/linkage"
    library = formula_opt_lib("libgit2")/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"eza", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
