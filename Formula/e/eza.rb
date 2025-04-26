class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "8ddaa84c655eba97c7287422bcd475defdaf1b7c28a609400ebf69da16d80b53"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ff00f2b27a4ffaac5b9e09cd09ec4446c2c6ad56d94b0e5d6d9758563f6ddd1"
    sha256 cellar: :any,                 arm64_sonoma:  "143bd41b9688466734c3f8f70e45a167016feb78e48f5a6b213075d46c825334"
    sha256 cellar: :any,                 arm64_ventura: "14a8cc9d85d33a59ae5b964299f8e83a51004514a3d8375268f8fa114a111241"
    sha256 cellar: :any,                 sonoma:        "df3acd77c96e1bc5d376c7441cddc5d0881eee95f23767832540787eebbda2d9"
    sha256 cellar: :any,                 ventura:       "b2368a2953522c5d172a54ccf5a1d245a11bbc424a5709bedb0677d246e06e9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "667acd7cf1543c6f386065ffcbd0b6a6d4dc44103836216281da01f26aecc14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ef6844c94336f5deb58834edbee02ab13a5453b722381a85e3cc13707f2c433"
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
