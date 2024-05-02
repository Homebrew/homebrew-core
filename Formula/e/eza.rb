class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.14.tar.gz"
  sha256 "f8f42ed466c02eaaa2b157ef976d29f1c38a6ff13064be52baed70e4943f2481"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4712e02af0b25aa12d4426fe3c66dd5c3e7e09a8c18d3288254bb8f519f44ec"
    sha256 cellar: :any,                 arm64_ventura:  "e7529cc3ae6267961e37089ccf6a002e1b5a475be150253213d0c0ecfb11d5c2"
    sha256 cellar: :any,                 arm64_monterey: "ed0b7ab8ded4bd8c8368b9c8aa0d8ad1511eded9a79b728580fc27d0354ea009"
    sha256 cellar: :any,                 sonoma:         "54a421a917dfa7a8a12f9827fa47e58265ef131ca89d740e9b3a220551e5fee4"
    sha256 cellar: :any,                 ventura:        "147233a4a684c905a9584970ad7ee9feeb113f8695ede4b43b14bd607b821c99"
    sha256 cellar: :any,                 monterey:       "aa2c64c8c9922bb4ad9bbda2c0673909d3922414cd69eb02f6c213239c835dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1527202d92472350625cf1b12495e317449ce78a52094cd90b7458ed5850e638"
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
