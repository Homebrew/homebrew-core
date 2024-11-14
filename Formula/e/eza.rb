class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.20.8.tar.gz"
  sha256 "10c32537e1c6d8dcd55d60e223dfb127dbec4c969132aeb503b2548213ef8541"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27a5529f35b6cc383e6f75cec41ac930ee31afd647ce8ed9444dff6c30471504"
    sha256 cellar: :any,                 arm64_sonoma:  "b63b38aebb33371f41212fdc5e89f1013f3293b04c8dd9921704f349f4b9c6ea"
    sha256 cellar: :any,                 arm64_ventura: "fa0ec590098e61a1b4be13533080a799fe9b5e9b0cdc3face86f00fc4347ea15"
    sha256 cellar: :any,                 sonoma:        "0e9e9e365730257d279e00de33eb3349593fadc520469b60ba1bf25ab8c3c169"
    sha256 cellar: :any,                 ventura:       "1d242c5c81983aa49e3ea7d3766e7e3da66e5587bb9145765a297a2f6990aa85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a9bb0b6d2692fc794e62781a494730cedcc1fa09246bd6816ad034c8fdb3954"
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
