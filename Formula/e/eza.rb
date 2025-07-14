class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "148eafa3e5eae4bdddd8cc7b2e666fc17853d43fbcc8f985dde0b22b58357916"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ddbf6f26892eba7512d612a554124b27d66da8779c6705395b2c2ee39ff5a14"
    sha256 cellar: :any,                 arm64_sonoma:  "f507413fbc26b44cb6459265bcd95bb38981e08cb1cfcf406437dbbc918b7409"
    sha256 cellar: :any,                 arm64_ventura: "590fbb18482336396d3162b1fe9a6d644f2cd3fb1e1cf720ab282c96e8a7ec43"
    sha256 cellar: :any,                 sonoma:        "0a354a95c2c8d8e82f3ee913316c4bc21c45da33fd4e50768498a3d360ad1cc0"
    sha256 cellar: :any,                 ventura:       "5c64fcf87745591cb515c28531ab923688891f3eba29fc335c137f97d1774832"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5f4d8249fb29a1db290c1c8cdcd1c57872634ef78ca0d0f462939e8171699e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04514fb496581ff5bcac0b54639854c570b6049aec5eb17a3dd51eb7b4f9cd41"
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
