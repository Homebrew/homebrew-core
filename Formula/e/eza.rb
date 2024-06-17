class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.18.tar.gz"
  sha256 "437ea76838fea2464b9592f1adef7df0412e27c9fc2a3e7ff47efcdfb17457f5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c3eadfc9c81742884c3d45bbb79245206c3498f9cc917d877b7fc31f63ec1eb8"
    sha256 cellar: :any,                 arm64_ventura:  "ca84616dc290841037b9d0390139c003d520b01197042be5426320f3db6e0e3e"
    sha256 cellar: :any,                 arm64_monterey: "cd08982de41eaa9d6c9d64e75843dcd21a65ead22d0d155460d1e0831bfefba0"
    sha256 cellar: :any,                 sonoma:         "be71d5bdd8198f1a05a74db70a76e3b231039f95c4aa6202c70b135bb92ef3c5"
    sha256 cellar: :any,                 ventura:        "b36755e5e8ceb4b88d254906cd1362154e9c0c63f306f13887098353fad960c5"
    sha256 cellar: :any,                 monterey:       "babefc16fef5b7be2187598daabd5fd2034140cbd871ea5b7a4480ba74dd2b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c83bd8ef9f52e1ad2b38159bfc51d53d605523a886c49174d070f9512f0a974"
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
