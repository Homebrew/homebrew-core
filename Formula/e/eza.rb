class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "8d5a573906fd362e27c601e8413b2c96b546bbac7cdedcbd1defe1332f42265d"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "831e284735fe8759d020b41080b827601ef4ccd6343ab710bd74caf35eb6a228"
    sha256 cellar: :any,                 arm64_sonoma:  "0f2335f0206a8c25d13d745b1c21e43b29575a40ba8ff6615fe5a9144bf01e1e"
    sha256 cellar: :any,                 arm64_ventura: "7413e4f2282a8031593303ab230cec8b090254600b6fbbd97b6247b9afa5b725"
    sha256 cellar: :any,                 sonoma:        "2fe3d06e1ea819d5984cf38be0a4b28135a8fede71903e6347aaa85dd99f6ee6"
    sha256 cellar: :any,                 ventura:       "8e2cf41f11a5fd9c7510120790cb3d96188c23aa496e07cedf1727589ee26bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6bad356fd74aeb758481d24162ce0f7a4cf788cca60ea353409ee5c4eb8c828"
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
