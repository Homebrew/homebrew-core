class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.10.1.tar.gz"
  sha256 "ff0fa0bfc4edef8bdbbb3cabe6fdbd5481a71abbbcc2159f402dea515353ae7c"
  license "MIT"
  revision 1
  head "https://github.com/ogham/exa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eae98c987e68e0940cb5f261b8d2fb98fe8f4f7b2d3fcf463c9b38494edeb351"
    sha256 cellar: :any,                 arm64_monterey: "4b57d8ffd16277cd825f13b629a8e6c75e9bebce9bec3432a36c375715b37b3a"
    sha256 cellar: :any,                 arm64_big_sur:  "7fd0284ff0a703050e5099619285060b6a0c6d687e291fd36e339a3e9182ae9a"
    sha256 cellar: :any,                 ventura:        "f38dc756d78e6cf42fdac94f2763642f112128d1ac5d8717dd72ba0c56b495da"
    sha256 cellar: :any,                 monterey:       "5021c8d446048e11b4bedc2836d91ed3d11f5a29e6d88085eb43921be26c1934"
    sha256 cellar: :any,                 big_sur:        "ebb304f59ba398ab7376e5dd59e7d48dd9937c01ef8d9cbb44e9a70424fce2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb7c0012074288ebd3331dd75c57c5e8957b7a8719fdc027597365f0ef379e53"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args

    if build.head?
      bash_completion.install "completions/bash/exa"
      zsh_completion.install  "completions/zsh/_exa"
      fish_completion.install "completions/fish/exa.fish"
    else
      # Remove after >0.10.1 build
      bash_completion.install "completions/completions.bash" => "exa"
      zsh_completion.install  "completions/completions.zsh"  => "_exa"
      fish_completion.install "completions/completions.fish" => "exa.fish"
    end

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "man/exa.1.md", "-o", "exa.1"
    system "pandoc", *args, "man/exa_colors.5.md", "-o", "exa_colors.5"
    man1.install "exa.1"
    man5.install "exa_colors.5"
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin/"exa")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time"
    exa_output = proc { shell_output("#{bin}/exa #{flags}").lines.grep(/#{testfile}/).first.split.first }
    system "git", "init"
    assert_equal "-N", exa_output.call
    system "git", "add", testfile
    assert_equal "N-", exa_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", exa_output.call

    linkage_with_libgit2 = (bin/"exa").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
